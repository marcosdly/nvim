Param([String]$Target)

$termRoot = (Get-Location).Path

function Build-LuaJIT() {
  # build LuaJIT
  try {
    Write-Output ':: Building LuaJIT'
    Set-Location ./LuaJIT/src
    msvcbuild.bat
    cd ..
    New-Item -Force -Path build,build/lua -ItemType Directory
    Copy-Item src/luajit.exe,src/lua51.dll -Destination build
    Copy-Item src/jit -Destination build/lua -Recurse
  } finally {
    Write-Output ':: Done Building LuaJIT'
    Set-Location $termRoot
  }
}

function Build-Neovim() {
  # build neovim
  try {
    Write-Output ':: Building Neovim'
    Set-Location ./neovim
    cmake.exe -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
    cmake.exe --build .deps --config Release
    cmake.exe -B build -D CMAKE_BUILD_TYPE=Release
    cmake.exe --build build --config Release
  } finally {
    Write-Output ':: Done Building Neovim'
    Set-Location $termRoot
  }
}

function Build-LazyNvim() {
  # build lazy.nvim
  try {
    Write-Output ':: Building lazy.nvim'
    Set-Location ./lazy.nvim/
    New-Item -Force -Path . -Name build -ItemType Directory
    Copy-Item lua -Destination build/luasrc -Recurse
    New-Item -Force -Path build -Name luaobj -ItemType Directory
    $src = Get-Item build/luasrc
    $obj = Get-Item build/luaobj
    $JIT = Get-Item ../LuaJIT/build/luajit.exe
    Get-ChildItem -Path luasrc -Include *.lua -Recurse | ForEach-Object {
      $input = [System.IO.FileSystemInfo]$_
      $output = [System.IO.Path]::GetRelativePath($src, $input)
        | %{ [System.IO.Path]::Combine($obj, $_) }
        | %{ [System.IO.Path]::ChangeExtension($_, 'lua.obj') }
      $outdir = [System.IO.Path]::GetDirectoryName($output)
      New-Item -Force -Path $outdir -ItemType Directory | Out-Null
      & $JIT -O3 -bsXd -t obj $input $output
    }
  } finally {
    Write-Output ':: Done Building lazy.nvim'
    Set-Location $termRoot
  }
}

function Package-Files() {
  # package files
  try {
    Write-Output ':: Packaging'
    New-Item -Force -Path . -Name build -ItemType Directory
    New-Item -Force -Path ./build -Name lua,nvim,luajit -ItemType Directory
    Copy-Item -Path ./neovim/build/bin ./build/nvim -Recurse
    Copy-Item -Path ./lazy.nvim/lua/lazy -Destination ./build/lua -Recurse
    Copy-Item -Path ./LuaJIT/build/* -Destination ./build/luajit -Recurse
  } finally {
    Write-Output ':: Done Packaging'
  }
}

switch ($Target) {
  'all' {
    Write-Output ':: Building all'
    Build-LuaJIT
    Build-Neovim
    Build-LazyNvim
    Package-Files
  }
  'jit' {
    Write-Output ':: Building LuaJIT'
    Build-LuaJIT
  }
  'neovim' {
    Write-Output ':: Building Neovim'
    Build-Neovim
  }
  'lazy' {
    Write-Output ':: Building LazyNvim'
    Build-LazyNvim
  }
  'package' {
    Write-Output ':: Packaging files'
    Package-Files
  }
}
