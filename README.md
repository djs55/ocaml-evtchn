[![Build stats](https://travis-ci.org/mirage/ocaml-evtchn.png?branch=master)](https://travis-ci.org/mirage/ocaml-evtchn)

Xen-style event channel implementations
=======================================

This package builds the following subpackages:

- xen-evtchn.unix: implements signalling using Unix domain sockets
  - (via module Unix_events : S.EVENTS)
- xen-gnt.xen: implements signalling via Xen event channels
  - (via module Xen_events : S.EVENTS)
- xen-gnt.xenctrl: implements signalling via libxc and Xen event channels
  - (via module Xenctrl_events : S.EVENTS)

To see a concrete example, have a look at [mirage/ocaml-vchan]
