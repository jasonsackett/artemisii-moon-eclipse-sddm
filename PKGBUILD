pkgname=sddm-theme-artemisii-moon-eclipse
pkgver=0.1.0
pkgrel=1
pkgdesc='Minimal static SDDM theme with an Artemis II lunar eclipse background'
arch=('any')
url=''
license=('custom')
depends=('sddm')
source=("artemisii-moon-eclipse-sddm.tar.gz")
sha256sums=('SKIP')

package() {
  install -dm755 "$pkgdir/usr/share/sddm/themes/artemisii-moon-eclipse"
  cp -r "$srcdir/artemisii-moon-eclipse-sddm/." "$pkgdir/usr/share/sddm/themes/artemisii-moon-eclipse/"
}
