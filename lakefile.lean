import Lake
open System Lake DSL

package EigenLean

@[default_target]
lean_lib EigenLean {
  -- precompileModules := true
  roots := #[`Eigen]
}

lean_exe dense {
  root := `examples.dense
  moreLinkArgs := #["-lc++", "-lc++abi", "-stdlib=c++","-L/home/tskrivan/.elan/toolchains/leanprover--lean4---nightly-2023-06-20/lib"]
}

lean_exe sparse {
  root := `examples.sparse
  moreLinkArgs := #["-stdlib=c++", "-lc++", "-L/home/tskrivan/.elan/toolchains/leanprover--lean4---nightly-2023-06-20/lib"]
}


target runCMake pkg : FilePath := do

  let cmakeLists ← inputFile <| pkg.dir / "cpp" / "CMakeLists.txt" 
  let cmakeLists ← cmakeLists.await
  
  IO.println s!"CMakeLists: {cmakeLists}"

  let _ ← IO.Process.run {
  -- proc {
    cmd := "mkdir"
    args := #["-p", pkg.buildDir / "cpp" |>.toString]
  }

  let _ ← IO.Process.run {
  -- proc {
    cmd := "cmake"
    args := #[ ".." / ".." / cmakeLists |>.toString,
              "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
                "-DCMAKE_BUILD_TYPE=Release",
                s!"-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES={← getLeanIncludeDir}","-B."]
    cwd := pkg.buildDir / "cpp"
  }

  return pure (pkg.buildDir / "cpp" )


extern_lib libEigenLean (pkg : Package) := do
  
  let cppDir ← fetch <| pkg.target `runCMake
  let cppDir ← cppDir.await

  let _ ← IO.Process.run {
  -- proc {
    cmd := "make"
    args := #["-j"]
    cwd := cppDir
  }

  let libFile := pkg.buildDir / "cpp" / "libEigenLean.a"
  
  return pure libFile

-- extern_lib libEigenLean pkg := do
--   let srcFiles := 
--     #[pkg.dir / "cpp" / "util.cpp",
--       pkg.dir / "cpp" / "LDLT.cpp",
--       pkg.dir / "cpp" / "SparseMatrix.cpp",
--       pkg.dir / "cpp" / "SparseSolvers.cpp"]

--   let mut buildJobs : Array (BuildJob FilePath) := Array.mkEmpty srcFiles.size
    
--   for srcFile in srcFiles do
--     let oFile := pkg.buildDir / "cpp" / (srcFile.withExtension "o").fileName.get!
--     let srcJob ← inputFile <| srcFile
--     let flags := #["-I", (← getLeanIncludeDir).toString, "-I/usr/include/eigen3", "-std=c++14","-fPIC"]
--     let job ← buildO srcFile.fileName.get! oFile srcJob flags "clang++"
--     buildJobs := buildJobs.push job

--   let name := nameToStaticLib "EigenLean"
--   -- buildLeanSharedLib (pkg.libDir / name) buildJobs #["-lc++", "-lc++abi", "-stdlib=c++","-L/home/tskrivan/.elan/toolchains/leanprover--lean4---nightly-2023-06-20/lib"]
--   buildStaticLib (pkg.libDir / name) buildJobs



-- #eval show IO Unit from do

--   let a : FilePath := default / "a" / "b.cpp"

--   IO.println a
--   IO.println (a.withExtension "o")
