# Standard ARM gcc compiler makefile.
# Copyright (c) 2019 by Johannes Berndorfer



# --- COMPILER MAKEFILE RULES ---

#%o: %c
#	@$(CC) -c $(CFLAGS) $(INC) $< -o $(BINFOLDER)/$@
#
#%o: %s
#	@$(ASM) -c $(ASMFLAGS) $< -o $(BINFOLDER)/$@
#
#%o: %cpp
#	@$(CPPC) -c $(CPPFLAGS) $(INC) $< -o $(BINFOLDER)/$@
#
#%elf: $(OBJ)
#	@$(CC) $(OBJ) $(LDFLAGS) $(LIBS) -o $(BINFOLDER)/$@
#
#%hex: %elf
#	@$(OBJCP) -O ihex $(BINFOLDER)/$< $(BINFOLDER)/$@
#
#%bin: %elf
#	@$(OBJCP) -O binary -S $(BINFOLDER)/$< $(BINFOLDER)/$@
#
#$(BINFOLDER):
#	mkdir $(BINFOLDER)