$NeovimBranch = 'v0.10.4'
$NeovimTarget = 'Release'
$NeovimCloneDir = "neovim-$NeovimBranch-$NeovimTarget"

function Start-Clean {
  Write-Output 'INFO: cleaning artifacts'
  Write-Output "INFO: deleting directory $NeovimCloneDir"
  Remove-Item -ErrorAction SilentlyContinue -Recurse -Force $NeovimCloneDir
}

function Start-GitClone {
  Write-Output 'INFO: clonning Neovim'
  git clone --depth 1 -b $NeovimBranch https://github.com/neovim/neovim.git $NeovimCloneDir
  Write-Output 'INFO: deleting .git directory'
  Remove-Item -ErrorAction SilentlyContinue -Recurse -Force "$NeovimCloneDir/.git"
}

function Start-Build {
  Write-Output "INFO: cd $NeovimCloneDir"
  Set-Location $NeovimCloneDir
  # build dependencies
  Write-Output 'INFO: building dependencies'
  cmake.exe -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=$NeovimTarget
  cmake.exe --build .deps --config $NeovimTarget
  # build neovim
  Write-Output 'INFO: building Neovim'
  cmake.exe -B build -D CMAKE_BUILD_TYPE=$NeovimTarget
  cmake.exe --build build --config $NeovimTarget
  Write-Output 'INFO: copying files back'
  Copy-Item -Recurse build/bin ../bin
  Write-Output 'INFO: finishing build'
  Set-Location ..
}

function Main {
  Start-Clean
  Start-GitClone
  Start-Build
}

Main
