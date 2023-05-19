pkgname='btrfs-backup'
pkgver='0.4'
pkgrel=1
arch=('any')
depends=('btrfs-progs' 'bash' 'grep' 'gawk' 'coreutils')

source=('shallowbackups.sh'
        'install.sh'
        'makebackup.sh'
)

sha1sums=('b90d87313ec0a5695fea88eeb2ca6cb98eb61c1f'
          '67707d4c44b594aeaa3fd9ade8929b9976d53094'
          '43b2206a656aa7e56bc9120b046ab37c9b26cda8')

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" PREFIX=/usr ./install.sh
}
