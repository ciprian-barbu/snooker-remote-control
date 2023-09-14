include <RemoteControlModules.scad>

// Diode cone block width
dcbw = 13.5;
// Diode cone block length
dcbl = 9;
// Diode cone block height
dcbh = 3.5;
// Diode diameter
dcdr = 5.1;
// Outer radius
dcor = 4;

//diode_cone_block(dcbw, dcbl, dcbh, dcdr/2, dcor);
diode_cone_block_half(dcbw, dcbl, dcbh, dcdr, dcor);
