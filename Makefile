PREFIX:=/usr
DESTDIR:=
PLATFORM:=linux

all:
	@echo "Run 'make install' to install."

install: install-$(PLATFORM)


.PHONY: install-openwrt

install-openwrt: install-lib
	install -m 0755 -d $(DESTDIR)/etc/hotplug.d/iface $(DESTDIR)/etc/{config,init.d}
	install -m 0755 platform/openwrt/sqm-hotplug $(DESTDIR)/etc/hotplug.d/iface/11-sqm
	install -m 0755 platform/openwrt/sqm-init $(DESTDIR)/etc/init.d/sqm
	install -m 0644 platform/openwrt/sqm-uci $(DESTDIR)/etc/config/sqm
	install -m 0744 src/run-openwrt.sh $(DESTDIR)$(PREFIX)/lib/sqm/run.sh

install-linux: install-lib
	install -m 0755 -d $(DESTDIR)$(PREFIX)/lib/systemd/system \
		$(DESTDIR)$(PREFIX)/lib/tmpfiles.d
	install -m 0644  platform/linux/sqm-eth0.conf.example $(DESTDIR)/etc/sqm
	install -m 0644  platform/linux/sqm@.service \
		$(DESTDIR)$(PREFIX)/lib/systemd/system
	install -m 0644  platform/linux/sqm-tmpfiles.conf \
		$(DESTDIR)$(PREFIX)/lib/tmpfiles.d/sqm.conf
	test -d $(DESTDIR)/etc/network/if-up.d && install -m 0755 platform/linux/sqm-ifup \
		$(DESTDIR)/etc/network/if-up.d/sqm || exit 0

.PHONY: install-lib

install-lib:
	install -m 0755 -d $(DESTDIR)/etc/sqm $(DESTDIR)$(PREFIX)/lib/sqm
	install -m 0644 platform/$(PLATFORM)/sqm.conf $(DESTDIR)/etc/sqm/sqm.conf
	install -m 0644  src/functions.sh src/defaults.sh \
		src/*.qos src/*.help $(DESTDIR)$(PREFIX)/lib/sqm
	install -m 0744  src/start-sqm src/stop-sqm $(DESTDIR)$(PREFIX)/lib/sqm
