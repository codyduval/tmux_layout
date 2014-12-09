bb62,159x48,0,0{79x48,0,0,79x48,80,0}
u_short
layout_checksum(const char *layout)
{
  u_short csum;

  csum = 0;
  for (; *layout != '\0'; layout++) {
    csum = (csum >> 1) + ((csum & 1) << 15);
    csum += *layout;
  }
  return (csum);
}
