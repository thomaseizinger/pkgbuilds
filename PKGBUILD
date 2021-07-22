# Maintainer: Thomas Eizinger <thomas@eizinger.io>

# All my PKGBUILDs are managed at https://github.com/thomaseizinger/pkgbuilds

pkgname=photoprism
pkgver="210523"
commit="b1856b9d"
pkgrel=1
epoch=
pkgdesc="Personal Photo Management powered by Go and Google TensorFlow "
arch=(x86_64 aarch64)
url="https://github.com/photoprism/photoprism"
license=('GPLv3')
groups=()
depends=(tensorflow115)
makedepends=(go nodejs npm)
checkdepends=()
optdepends=()
provides=("photoprism")
conflicts=("photoprism")
replaces=()
backup=("etc/photoprism/options.yml")
options=()
install=
changelog=
source=("https://github.com/photoprism/photoprism/archive/$pkgver-$commit.tar.gz" "https://dl.photoprism.org/tensorflow/nasnet.zip" "https://dl.photoprism.org/tensorflow/nsfw.zip" "photoprism.service" "photoprism.sysusers" "options.yml")
noextract=()
sha256sums=('86f7e344ce628c3bd1076948f9340999bb4743aa9e7402fc14f4e3106f8aed89'
            'a0e1ad8d5a5a0ff9efc4b3ed89898bf008563ee36cacd0c804a384f8fc661588'
            'eb5e5d22e37961c3192a4757efff883f77bc989c0efceabb1395e0959d966f14'
            'SKIP'
            'SKIP'
            'SKIP')
validpgpkeys=()

build() {
	cd "$pkgname"-"$pkgver"-"$commit"
	scripts/build.sh prod ./photoprism

	cd "frontend";
	npm install
	NODE_ENV=production npm run build
}

check() {
	"$pkgname"-"$pkgver"-"$commit/photoprism" --version
}

package() {
	install -Dm 0644 "${srcdir}/photoprism.service" "${pkgdir}/usr/lib/systemd/system/photoprism.service"
	install -Dm 0644 "${srcdir}/photoprism.sysusers" "${pkgdir}/usr/lib/sysusers.d/photoprism.conf"

	mkdir -p "$pkgdir/etc/photoprism"
	install -Dm 0444 "${srcdir}/options.yml" "$pkgdir/etc/photoprism/options.yml"

	mkdir -p "$pkgdir/var/lib/photoprism/assets/"

	cp -r "${srcdir}/nasnet" "${srcdir}/nsfw" "$pkgdir/var/lib/photoprism/assets/"

	cd "$pkgname"-"$pkgver"-"$commit"

	install -Dm 0755 ./photoprism "$pkgdir/usr/bin/photoprism"
	cp -r assets/locales assets/profiles assets/static assets/templates "$pkgdir/var/lib/photoprism/assets/"

	find "$pkgdir/var/lib/photoprism/assets/" -type d -exec chmod +x {} \;
}
