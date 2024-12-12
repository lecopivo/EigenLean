import Lake
open System Lake DSL

package eigenlean

def linkArgs :=
    #["-L./.lake/build/cpp",
      "-lEigenLeanCpp",
      "-Wl,-rpath,./.lake/build/cpp"]

@[default_target]
lean_lib EigenLean {
  defaultFacets := #[LeanLib.sharedFacet,LeanLib.staticFacet]
  moreLinkArgs := linkArgs
  roots := #[`Eigen]
}

lean_exe dense {
  root := `examples.dense
  moreLinkArgs := linkArgs
}

lean_exe sparse {
  root := `examples.sparse
  moreLinkArgs := linkArgs
}


script buildEigen args := do
  let _makeBuildDir ← IO.Process.run {
    cmd := "mkdir"
    args := #["-p", (defaultBuildDir / "cpp").toString]
  }

  let _runCMake ← IO.Process.run {
    cmd := "cmake"
    args := #["../../../cpp", "-DCMAKE_EXPORT_BUILD_DATABASE=1" ,s!"-DLEAN_SYSROOT={← Lean.findSysroot}"]
    cwd := defaultBuildDir / "cpp"
  }

  IO.println _runCMake

  let _runMake ← IO.Process.run {
    cmd := "make"
    args := #[]
    cwd := defaultBuildDir / "cpp"
  }

  IO.println _runMake

  return 0


target eigenlib pkg : FilePath := do

  let name := nameToSharedLib "EigenLeanCpp"
  let path := pkg.buildDir / "cpp" / name

  -- glob all source files
  let mut inputs : List (BuildJob FilePath) := []
  for file in (← (pkg.dir / "cpp").readDir) do
    unless file.path.extension = some "h" ||
           file.path.extension = some "cpp" do continue
    let job ← inputFile file.path true
    inputs := job :: inputs


  inputFile path true

  -- for some reasong this builds almost empty shared library
  -- buildFileAfterDepList path inputs fun _ => do
  --   let _ ← buildEigen []
  --   pure ()
