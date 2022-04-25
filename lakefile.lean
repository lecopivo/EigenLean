import Lake
open System Lake DSL

package EigenLean (pkgDir) (args) {
  -- defaultFacet := PackageFacet.staticLib
  moreLinkArgs := #["-L", defaultBuildDir / "cpp" |>.toString, "-lEigenLeanCpp"]
}

script compileCpp (args) do

  -- make build directory
  let makeBuildDir ← IO.Process.run {
    cmd := "mkdir"
    args := #["-p", "build/cpp"]
  }

  -- run cmake
  if ¬(← defaultBuildDir / "cpp" / "Makefile" |>.pathExists) then
    let runCMake ← IO.Process.spawn {
      cmd := "cmake"
      args := #["../../cpp", 
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
                "-DCMAKE_BUILD_TYPE=Release",
                s!"-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES={← getLeanIncludeDir}"]
      cwd := defaultBuildDir / "cpp" |>.toString
      
    }
    let out ← runCMake.wait
    if out != 0 then
      return out

  -- run make 
  let runMake ← IO.Process.spawn {
    cmd := "make"
    args := #["-j"]
    cwd := defaultBuildDir / "cpp" |>.toString
  }
  let out ← runMake.wait
  if out != 0 then
    return out 

  return 0

  



