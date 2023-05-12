pkgname='btrfs-backup'
pkgver='0.3'
pkgrel=1
arch=('any')
depends=('btrfs-progs' 'bash' 'grep' 'gawk' 'coreutils')

source=('backup.sh'
        'install.sh'
        'makebackup.sh'
)

sha1sums=('210128563b00d0fe6c2506a84eca5bd8b6054d85'
          '9af3f1be5b0e819da2b4162cdc69760b5f1d3f95'
          '66ad3af8ad56bd2567527b16a0dc0e8c16bd0f58')

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" PREFIX=/usr ./install.sh
}
