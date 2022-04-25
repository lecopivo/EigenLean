import Lake
open System Lake DSL

package EigenLean (pkgDir) (args) {
  defaultFacet := PackageFacet.staticLib
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

script buildExamples (args) do

  let examplesDir := (← IO.currentDir) / "examples"

  let makeBuildDir ← IO.Process.run {
    cmd := "mkdir"
    args := #["-p", "build/examples"]
  }

  for f in (← examplesDir.readDir) do
    if f.path.extension.getD "" == "lean" then

      let cFile := defaultBuildDir / "examples" / (f.path.withExtension "c" |>.fileName.getD "")
      let makeCCode ← IO.Process.spawn {
        cmd := "lake"
        args := #["env", "lean", f.path.toString, "-c", cFile.toString]
      }
      let out ← makeCCode.wait

      let outFile := defaultBuildDir / "examples" / (f.path.withExtension "" |>.fileName.getD "")
      let build ← IO.Process.spawn {
        cmd := "leanc"
        args := #[cFile |>.toString, 
                  "-o", outFile |>.toString,
                  "-L./build/lib", "-lEigenLean",
                  "-L./build/cpp", "-lEigenLeanCppStatic"]
      }
      let out ← build.wait

  return 0
  



