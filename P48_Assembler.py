##########################################################
# 
# Welcome to my very vanilla (and verbose) Assembler !
#
# Author : Perceptronium
# Date : 18-11-2020
#
# Note : 
# This is for my own understanding of Assemblers. It 
# really is not robust at all but it serves its purpose which
# is to understand how assemblers work.
#
###########################################################

import sys
import re

# Let's start assembling our instructions

# We'll assume user calls >> Assemble.py Assembly.asm

# This is for an 8-bit Harvard architecture with 4 registers and 1 pipeline
# Instructions are also 8-bits long

# Typical instruction :
#	ADD R1, 0x0


with open(sys.argv[1]) as Set:
	for Inst in Set:

		# Ignoring standard comments 
		if Inst[0] == '/':
			continue

		if Inst[0] == '*':
			continue

		if Inst[0] == ';':
			continue

		# Ignoring standard labels
		if Inst[0] == '.':
			continue

		# Replace Carriage Return characters by spaces
		Inst = Inst.replace('\n', '').replace('\r', '')

		# RegEx to cut down the commas
		Unit = re.split(r'[, ]',line)

		# Let's get rid of the space now
		if '' in Unit:
			Unit.remove('')

		# Let's get ready to rumble. This is gonna be boring and pretty straight-forward
		if Unit[0].upper() == "ADD":
			Reg = int(Unit[1].upper()[1])
			if Reg >= 1 && Reg <= 4:
				Data = int(Unit[2])
				# Continuer ici

		if Unit[0].upper() == "SUB"

		if Unit[0].upper() == "LOAD"

		if Unit[0].upper() == "STORE"	