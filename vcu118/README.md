# VCU118 and KCU1500 attempts 

## Packages, Pins, GTs

 - VCU118 has VU9P in the FLGA2104 package
 - KCU1500 has KU115 in the FLVB2014 package
 - A2104 and B2104 are the only packages that are compatible with both VU9P and KU115

 - For the VU9P, the GTY transcievers available are:
   - A2104: 56 links: quads 224 225 226 227 231 232 233 120 121 122 125 126 127
      - Quad mapping in VCU118: FireFly quad (233), QSFP 1-2 (quad 231, 232), PCIExpress (224 225 226 227)
   - B2104: 76 links: quads 224 225 226 227 228 229 230 231 232 233 120 121 122 123 124 125 126 127 128
   - C2104: 104 links: quads 224 225 226 227 228 229 230 231 232 233 220 221 222 124 125 126 127 128 129 130 131 132 133 120 121 122
   - D2104: 76 links 
   - A2577: 120 links (max available): 224 225 226 227 228 229 230 231 232 233 219 220 221 222 223 124 125 126 127 128 129 130 131 132 133 119 120 121 122 123

 - For the KU115:
   - A2104: 52 links: quads 224 225 226 227 231 232 233 126 127 128 131 132 133
   - B2104: 64 links (max available): quads 224 225 226 227 228 229 230 231 232 233 126 127 128 131 132 133
      - Quad mapping in KU115: QSFP 1-2 (quad 127 128), PCIExpress (224 225 226 227)

