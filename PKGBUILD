pkgname='backup'
pkgver='0.1'
pkgrel=1
arch=('any')
depends=('btrfs-progs' 'bash' 'grep' 'gawk' 'coreutils')

source=('backup.sh'
        'install.sh'
        'makebackup.sh'
        'backup@.service'
)

sha1sums=('210128563b00d0fe6c2506a84eca5bd8b6054d85'
          '204b0612b86a96253dd69dab5bd28a1f0832c239'
          'c25b45d7da72d920001349a870dc952b7c291336'
          '7a75733896b97dee46429112b23c687d38284e3e')

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" PREFIX=/usr ./install.sh
}
