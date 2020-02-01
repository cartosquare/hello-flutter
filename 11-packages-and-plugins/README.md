# Packages & plugins <!-- omit in toc -->

## 目录 <!-- omit in toc -->
- [Using packages](#using-packages)
    - [Searching for package](#searching-for-package)
    - [Adding a package dependency to an app](#adding-a-package-dependency-to-an-app)
    - [Conflict resolution](#conflict-resolution)
  - [Developing new packages](#developing-new-packages)
    - [Managing package dependencies and versions](#managing-package-dependencies-and-versions)
      - [Package versions](#package-versions)
      - [Updating package dependencies](#updating-package-dependencies)
    - [Dependencies on unpublished packages](#dependencies-on-unpublished-packages)
- [Developing packages & plugins](#developing-packages--plugins)
- [Flutter FAvorite program](#flutter-favorite-program)
- [Background processes](#background-processes)
- [Android plugin upgrade](#android-plugin-upgrade)
- [Package site](#package-site)


## Using packages

使用已发布的公开库

#### Searching for package

代码库在[pub.dev](https://pub.dev/)

#### Adding a package dependency to an app

1. Depend on it
2. Install it
3. Import it
4. Stop and restart the app, if necessary

#### Conflict resolution

尽量申明兼容的版本号：
```dart
dependencies:
  url_launcher: ^0.4.2    # Good, any 0.4.x version where x >= 2 works.
  image_picker: '0.1.1'   # Not so good, only version 0.1.1 works.
```

另外，可以使用`dependency override`强制使用某个版本号：

```
dependencies:
  some_package:
  another_package:
dependency_overrides:
  url_launcher: '0.4.3'
```

### Developing new packages

#### Managing package dependencies and versions

为了减小版本冲突的风险，尽量`pubspec.yaml`文件中指定一个版本范围。

##### Package versions

使用方式：

```
dependencies:
  url_launcher: '>=0.1.2 <0.2.0'
```

或：

```
dependencies:
  collection: '^0.1.2'
```

##### Updating package dependencies

使用下面的命令下载：

```
flutter pub get
```

使用下面的命令更新新版本：

```
flutter pub upgrade
```

#### Dependencies on unpublished packages

几种方式：

* 路径依赖

```
dependencies:
  plugin1:
    path: ../plugin1/
```
* Git 仓库依赖

```
dependencies:
  plugin1:
    git:
      url: git://github.com/flutter/plugin1.git
```

* Git 仓库内的目录依赖

```
dependencies:
  package1:
    git:
      url: git://github.com/flutter/packages.git
      path: packages/package1
```


## Developing packages & plugins

[TBD]

## Flutter FAvorite program

see `https://pub.dev/flutter/favorites`

## Background processes

[TBD]

## Android plugin upgrade

[TBD]

## Package site

`https://pub.dev/flutter/packages`