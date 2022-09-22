
## Build LDC runtime

Tested only on Ubuntu 22.04.
CMake required.


### 1 install `musl`

```sh
sudo apt install musl
sudo apt install musl-tools
sudo apt install musl-dev
```

### 2 build libraries

```sh
CC=musl-gcc ldc-build-runtime --dFlags="--flto=full" --cFlags="-O3" BUILD_SHARED=OFF
```

## 3 install

By default it installs under `/usr/local`.

```sh
cd ldc-build-runtime.tmp
sudo make install
```

To change the install prefix:
```sh
cd ldc-build-runtime.tmp
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make all install
```

## Configure compilation

`dub.json`
```sh
	"dflags": ["-static"],
	"lflags": ["-static"],
```

## Build application

When building with `dub` set the `DC` environment variable to `ldc2`:

```sh
DC=ldc2 dub build
```
