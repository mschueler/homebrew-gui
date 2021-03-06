class Xchat < Formula
  desc "An IRC chat program"
  homepage "http://xchat.org"
  url "http://xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2"
  sha256 "0d6d69437b5e1e45f3e66270fe369344943de8a1190e498fafa5296315a27db0"
  revision 2

  bottle do
    sha256 "8583f805e448478b0740327718d5bc2cd5bfba11e78f5af366ed97a6a6d81822" => :el_capitan
    sha256 "b4a8763d93edf4f7476e79377f8e2e610b88c4839a612a7cc81006ec7bc4828b" => :yosemite
    sha256 "9fe2f32450cbde4022bb3337105de0dba3f877453bf8445c545e88f3c038362c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gettext"
  depends_on "gtk+"

  # Adjust to newer glib include conventions
  # Reported at https://sourceforge.net/tracker/?func=detail&aid=3446968&group_id=239&atid=100239
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-openssl
      --disable-python
      --disable-xlib
      --disable-perl
      --disable-plugin
    ]

    # Fails on 32-bit core solo without this
    args << "--disable-mmx" unless MacOS.prefer_64_bit?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xchat", "-v"
  end
end

__END__
diff --git a/src/common/servlist.c b/src/common/servlist.c
index 1728928..0829c99 100644
--- a/src/common/servlist.c
+++ b/src/common/servlist.c
@@ -24,7 +24,7 @@
 #include <unistd.h>

 #include "xchat.h"
-#include <glib/ghash.h>
+#include <glib.h>

 #include "cfgfiles.h"
 #include "fe.h"
diff --git a/src/common/text.c b/src/common/text.c
index a219851..6b11174 100644
--- a/src/common/text.c
+++ b/src/common/text.c
@@ -28,7 +28,7 @@
 #include <sys/mman.h>

 #include "xchat.h"
-#include <glib/ghash.h>
+#include <glib.h>
 #include "cfgfiles.h"
 #include "chanopt.h"
 #include "plugin.h"
diff --git a/src/common/util.c b/src/common/util.c
index 49517ec..5a0ab6c 100644
--- a/src/common/util.c
+++ b/src/common/util.c
@@ -39,7 +39,7 @@
 #include <errno.h>
 #include "xchat.h"
 #include "xchatc.h"
-#include <glib/gmarkup.h>
+#include <glib.h>
 #include <ctype.h>
 #include "util.h"
 #include "../../config.h"
diff --git a/src/common/xchat.h b/src/common/xchat.h
index 013d6a1..e3f15a8 100644
--- a/src/common/xchat.h
+++ b/src/common/xchat.h
@@ -1,10 +1,6 @@
 #include "../../config.h"

-#include <glib/gslist.h>
-#include <glib/glist.h>
-#include <glib/gutils.h>
-#include <glib/giochannel.h>
-#include <glib/gstrfuncs.h>
+#include <glib.h>
 #include <time.h>			/* need time_t */
