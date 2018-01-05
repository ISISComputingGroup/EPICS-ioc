program coord("PVONE,PVTWO,PVONE_DISP,PVTWO_DISP")

ss coord
{

  /* Initial state. Find the current state and move into it. */
  state unknown
  {
    when(1 == 1)
	{
	  puts("Hello");
	} state unknown
  }
}
