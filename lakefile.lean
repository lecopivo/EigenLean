import Lake
open System Lake DSL

package EigenLean

@[default_target]
lean_lib EigenLean {
  roots := #[`Eigen]
}

lean_exe dense {
  root := `examples.dense
  moreLinkArgs := #["-stdlib=c++"]
}

lean_exe sparse {
  root := `examples.sparse
  moreLinkArgs := #["-stdlib=c++"]
}

extern_lib libEigenLean pkg := do
  let srcFiles := 
    #[pkg.dir / "cpp" / "util.cpp",
      pkg.dir / "cpp" / "LDLT.cpp",
      pkg.dir / "cpp" / "SparseMatrix.cpp",
      pkg.dir / "cpp" / "SparseSolvers.cpp"]

  let mut buildJobs : Array (BuildJob FilePath) := Array.mkEmpty srcFiles.size
    
  for srcFile in srcFiles do
    let oFile := pkg.buildDir / "cpp" / (srcFile.withExtension "o").fileName.get!
    let srcJob ← inputFile <| srcFile
    let flags := #["-I", (← getLeanIncludeDir).toString, "-I/usr/include/eigen3", "-std=c++14","-fPIC"]
    let job ← buildO srcFile.fileName.get! oFile srcJob flags 
    buildJobs := buildJobs.push job

  let name := nameToStaticLib "EigenLean"
  buildStaticLib (pkg.libDir / name) buildJobs
