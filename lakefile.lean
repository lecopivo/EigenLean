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
}

lean_exe sparse {
  root := `examples.sparse
}


target runCMake pkg : FilePath := do

  let cmakeLists ← inputFile <| pkg.dir / "cpp" / "CMakeLists.txt" 
  let cmakeLists ← cmakeLists.await
  
  IO.println s!"CMakeLists: {cmakeLists}"

  let _ ← IO.Process.run {
    cmd := "mkdir"
    args := #["-p", pkg.buildDir / "cpp" |>.toString]
  }

  proc {
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

  proc {
    cmd := "make"
    args := #["-j"]
    cwd := cppDir
  }

  let libFile := pkg.buildDir / "cpp" / "libEigenLean.a"
  
  return pure libFile

