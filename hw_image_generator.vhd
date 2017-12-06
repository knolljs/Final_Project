--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;


ENTITY hw_image_generator IS
	GENERIC(
		pixels_y 	:	INTEGER := 427;    --row that first color will persist until
		pixels_x	:	INTEGER := 342);   --column that first color will persist until
	PORT(
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		clk_1			: 	IN 	STD_LOGIC;
		up				:	IN		STD_LOGIC;
		down			:	IN		STD_LOGIC;
		l				:	IN		STD_LOGIC;
		r				:	IN		STD_LOGIC;
		s				:  IN    STD_LOGIC;
		A				:  OUT   STD_LOGIC;
		B				:  OUT   STD_LOGIC;
		C				:  OUT   STD_LOGIC;
		D				:  OUT   STD_LOGIC;
		E				:  OUT   STD_LOGIC;
		F				:  OUT   STD_LOGIC;
		G				:  OUT   STD_LOGIC;
		A1				:  OUT   STD_LOGIC;
		B10			:  OUT   STD_LOGIC;
		C1				:  OUT   STD_LOGIC;
		D1				:  OUT   STD_LOGIC;
		E1				:  OUT   STD_LOGIC;
		F1				:  OUT   STD_LOGIC;
		G10			:  OUT   STD_LOGIC;
		A2				:  OUT   STD_LOGIC;
		B20			:  OUT   STD_LOGIC;
		C2				:  OUT   STD_LOGIC;
		D2				:  OUT   STD_LOGIC;
		E2				:  OUT   STD_LOGIC;
		F2				:  OUT   STD_LOGIC;
		G20			:  OUT   STD_LOGIC;
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
	type state_type is (STATE_0, STATE_1, STATE_2, STATE_3, STATE_4, STATE_5, STATE_6, STATE_7, STATE_8, STATE_9);
	signal state : state_type := STATE_0;
	type state_type1 is (STATE_00, STATE_10, STATE_20, STATE_30, STATE_40, STATE_50, STATE_60, STATE_70, STATE_80, STATE_90);
	signal state1 : state_type1 := STATE_00;
	type state_type2 is (STATE_000, STATE_100, STATE_200, STATE_300, STATE_400, STATE_500, STATE_600, STATE_700, STATE_800, STATE_900);
	signal state2 : state_type2 := STATE_000;
	signal black	: INTEGER := 5;
	signal bl		: INTEGER := 0;
	signal re		: INTEGER := 1;
	signal blue2	: INTEGER := 8;
	signal pink		: INTEGER := 2;
	signal gr		: INTEGER := 3;
	signal turq		: INTEGER := 6;
	signal yellow	: INTEGER := 4;
	signal white	: INTEGER := 7;
	signal moves   : INTEGER := 0;
	signal R0		: STD_LOGIC := '0';
	signal R1		: STD_LOGIC := '0';
	signal R2		: STD_LOGIC := '0';
	signal R3		: STD_LOGIC := '0';
	signal R4		: STD_LOGIC := '0';
	signal R5		: STD_LOGIC := '0';
	signal R6		: STD_LOGIC := '0';
	signal R7		: STD_LOGIC := '0';
	signal R8		: STD_LOGIC := '0';
	signal G0		: STD_LOGIC := '0';
	signal G1		: STD_LOGIC := '0';
	signal G2		: STD_LOGIC := '0';
	signal G3		: STD_LOGIC := '0';
	signal G4		: STD_LOGIC := '0';
	signal G5		: STD_LOGIC := '0';
	signal G6		: STD_LOGIC := '0';
	signal G7		: STD_LOGIC := '0';
	signal G8		: STD_LOGIC := '0';
	signal B0		: STD_LOGIC := '0';
	signal B1		: STD_LOGIC := '0';
	signal B2		: STD_LOGIC := '0';
	signal B3		: STD_LOGIC := '0';
	signal B4		: STD_LOGIC := '0';
	signal B5		: STD_LOGIC := '0';
	signal B6		: STD_LOGIC := '0';
	signal B7		: STD_LOGIC := '0';
	signal B8		: STD_LOGIC := '0';
	signal counter : STD_LOGIC_VECTOR (24 DOWNTO 0) := (OTHERS => '0');
BEGIN
		R0 <= '1' when re = 0 OR white = 0 OR pink = 0 OR yellow = 0 else
				'0' when bl = 0 OR blue2 = 0 OR gr = 0 OR black = 0 OR turq = 0;
		R1 <= '1' when re = 1 OR white = 1 OR pink = 1 OR yellow = 1 else
				'0' when bl = 1 OR blue2 = 1 OR gr = 1 OR black = 1 OR turq = 1;
		R2 <= '1' when re = 2 OR white = 2 OR pink = 2 OR yellow = 2 else
				'0' when bl = 2 OR blue2 = 2 OR gr = 2 OR black = 2 OR turq = 2;
		R3 <= '1' when re = 3 OR white = 3 OR pink = 3 OR yellow = 3 else
				'0' when bl = 3 OR blue2 = 3 OR gr = 3 OR black = 3 OR turq = 3;
		R4 <= '1' when re = 4 OR white = 4 OR pink = 4 OR yellow = 4 else
				'0' when bl = 4 OR blue2 = 4 OR gr = 4 OR black = 4 OR turq = 4;
		R5 <= '1' when re = 5 OR white = 5 OR pink = 5 OR yellow = 5 else
				'0' when bl = 5 OR blue2 = 5 OR gr = 5 OR black = 5 OR turq = 5;
		R6 <= '1' when re = 6 OR white = 6 OR pink = 6 OR yellow = 6 else
				'0' when bl = 6 OR blue2 = 6 OR gr = 6 OR black = 6 OR turq = 6;
		R7 <= '1' when re = 7 OR white = 7 OR pink = 7 OR yellow = 7 else
				'0' when bl = 7 OR blue2 = 7 OR gr = 7 OR black = 7 OR turq = 7;
		R8 <= '1' when re = 8 OR white = 8 OR pink = 8 OR yellow = 8 else
				'0' when bl = 8 OR blue2 = 8 OR gr = 8 OR black = 8 OR turq = 8;
		G0 <= '1' when gr = 0 OR white = 0 OR turq = 0 OR yellow = 0 else
				'0' when bl = 0 OR blue2 = 0 OR re = 0 OR black = 0 OR pink = 0;
		G1 <= '1' when gr = 1 OR white = 1 OR turq = 1 OR yellow = 1 else
				'0' when bl = 1 OR blue2 = 1 OR re = 1 OR black = 1 OR pink = 1;
		G2 <= '1' when gr = 2 OR white = 2 OR turq = 2 OR yellow = 2 else
				'0' when bl = 2 OR blue2 = 2 OR re = 2 OR black = 2 OR pink = 2;
		G3 <= '1' when gr = 3 OR white = 3 OR turq = 3 OR yellow = 3 else
				'0' when bl = 3 OR blue2 = 3 OR re = 3 OR black = 3 OR pink = 3;
		G4 <= '1' when gr = 4 OR white = 4 OR turq = 4 OR yellow = 4 else
				'0' when bl = 4 OR blue2 = 4 OR re = 4 OR black = 4 OR pink = 4;
		G5 <= '1' when gr = 5 OR white = 5 OR turq = 5 OR yellow = 5 else
				'0' when bl = 5 OR blue2 = 5 OR re = 5 OR black = 5 OR pink = 5;
		G6 <= '1' when gr = 6 OR white = 6 OR turq = 6 OR yellow = 6 else
				'0' when bl = 6 OR blue2 = 6 OR re = 6 OR black = 6 OR pink = 6;
		G7 <= '1' when gr = 7 OR white = 7 OR turq = 7 OR yellow = 7 else
				'0' when bl = 7 OR blue2 = 7 OR re = 7 OR black = 7 OR pink = 7;
		G8 <= '1' when gr = 8 OR white = 8 OR turq = 8 OR yellow = 8 else
				'0' when bl = 8 OR blue2 = 8 OR re = 8 OR black = 8 OR pink = 8;
		B0 <= '1' when bl = 0 OR white = 0 OR pink = 0 OR blue2 = 0 OR turq = 0 else
				'0' when re = 0 OR yellow = 0 OR gr = 0 OR black = 0;
		B1 <= '1' when bl = 1 OR white = 1 OR pink = 1 OR blue2 = 1 OR turq = 1 else
				'0' when re = 1 OR yellow = 1 OR gr = 1 OR black = 1;
		B2 <= '1' when bl = 2 OR white = 2 OR pink = 2 OR blue2 = 2 OR turq = 2 else
				'0' when re = 2 OR yellow = 2 OR gr = 2 OR black = 2;
		B3 <= '1' when bl = 3 OR white = 3 OR pink = 3 OR blue2 = 3 OR turq = 3 else
				'0' when re = 3 OR yellow = 3 OR gr = 3 OR black = 3;
		B4 <= '1' when bl = 4 OR white = 4 OR pink = 4 OR blue2 = 4 OR turq = 4 else
				'0' when re = 4 OR yellow = 4 OR gr = 4 OR black = 4;
		B5 <= '1' when bl = 5 OR white = 5 OR pink = 5 OR blue2 = 5 OR turq = 5 else
				'0' when re = 5 OR yellow = 5 OR gr = 5 OR black = 5;
		B6 <= '1' when bl = 6 OR white = 6 OR pink = 6 OR blue2 = 6 OR turq = 6 else
				'0' when re = 6 OR yellow = 6 OR gr = 6 OR black = 6;
		B7 <= '1' when bl = 7 OR white = 7 OR pink = 7 OR blue2 = 7 OR turq = 7 else
				'0' when re = 7 OR yellow = 7 OR gr = 7 OR black = 7;
		B8 <= '1' when bl = 8 OR white = 8 OR pink = 8 OR blue2 = 8 OR turq = 8 else
				'0' when re = 8 OR yellow = 8 OR gr = 8 OR black = 8;
	DISPLAYMOVES : PROCESS(clk_1, moves)
	BEGIN
	if (clk_1'event and clk_1 = '1') then
				case state is
					when STATE_0 =>
						A <= '0';
						B <= '0';
						C <= '0';
						D <= '0';
						E <= '0';
						F <= '0';
						G <= '1';
						IF (moves rem 10 = 1) THEN
							state <= STATE_1;
						END IF;
					when STATE_1 =>
						A <= '1';
						B <= '0';
						C <= '0';
						D <= '1';
						E <= '1';
						F <= '1';
						G <= '1';
						IF (moves rem 10 = 2) THEN
							state <= STATE_2;
						END IF;
					when STATE_2 =>
						A <= '0';
						B <= '0';
						C <= '1';
						D <= '0';
						E <= '0';
						F <= '1';
						G <= '0';
						IF (moves rem 10 = 3) THEN
							state <= STATE_3;
						END IF;
					when STATE_3 =>
						A <= '0';
						B <= '0';
						C <= '0';
						D <= '0';
						E <= '1';
						F <= '1';
						G <= '0';
						IF (moves rem 10 = 4) THEN
							state <= STATE_4;
						END IF;
					when STATE_4 =>
						A <= '1';
						B <= '0';
						C <= '0';
						D <= '1';
						E <= '1';
						F <= '0';
						G <= '0';
						IF (moves rem 10 = 5) THEN
							state <= STATE_5;
						END IF;
					when STATE_5 =>
						A <= '0';
						B <= '1';
						C <= '0';
						D <= '0';
						E <= '1';
						F <= '0';
						G <= '0';
						IF (moves rem 10 = 6) THEN
							state <= STATE_6;
						END IF;
					when STATE_6 =>
						A <= '0';
						B <= '1';
						C <= '0';
						D <= '0';
						E <= '0';
						F <= '0';
						G <= '0';
						IF (moves rem 10 = 7) THEN
							state <= STATE_7;
						END IF;
					when STATE_7 =>
						A <= '0';
						B <= '0';
						C <= '0';
						D <= '1';
						E <= '1';
						F <= '1';
						G <= '1';
						IF (moves rem 10 = 8) THEN
							state <= STATE_8;
						END IF;
					when STATE_8 =>
						A <= '0';
						B <= '0';
						C <= '0';
						D <= '0';
						E <= '0';
						F <= '0';
						G <= '0';
						IF (moves rem 10 = 9) THEN
							state <= STATE_9;
						END IF;
					when STATE_9 =>
						A <= '0';
						B <= '0';
						C <= '0';
						D <= '1';
						E <= '1';
						F <= '0';
						G <= '0';
						IF (moves rem 10 = 0) THEN
							state <= STATE_0;
						END IF;
					when others => null;
				END CASE;
	END IF;
	END PROCESS DISPLAYMOVES;
	DISPLAYMOVES1 : PROCESS(clk_1, moves)
	BEGIN
	if (clk_1'event and clk_1 = '1') then
				case state1 is
					when STATE_00 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '0';
						D1 <= '0';
						E1 <= '0';
						F1 <= '0';
						G10 <= '1';
						IF ((moves/10) rem 10 = 1) THEN
							state1 <= STATE_10;
						END IF;
					when STATE_10 =>
						A1 <= '1';
						B10 <= '0';
						C1 <= '0';
						D1 <= '1';
						E1 <= '1';
						F1 <= '1';
						G10 <= '1';
						IF ((moves/10) rem 10 = 2) THEN
							state1 <= STATE_20;
						END IF;
					when STATE_20 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '1';
						D1 <= '0';
						E1 <= '0';
						F1 <= '1';
						G10 <= '0';
						IF ((moves/10) rem 10 = 3) THEN
							state1 <= STATE_30;
						END IF;
					when STATE_30 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '0';
						D1 <= '0';
						E1 <= '1';
						F1 <= '1';
						G10 <= '0';
						IF ((moves/10) rem 10 = 4) THEN
							state1 <= STATE_40;
						END IF;
					when STATE_40 =>
						A1 <= '1';
						B10 <= '0';
						C1 <= '0';
						D1 <= '1';
						E1 <= '1';
						F1 <= '0';
						G10 <= '0';
						IF ((moves/10) rem 10 = 5) THEN
							state1 <= STATE_50;
						END IF;
					when STATE_50 =>
						A1 <= '0';
						B10 <= '1';
						C1 <= '0';
						D1 <= '0';
						E1 <= '1';
						F1 <= '0';
						G10 <= '0';
						IF ((moves/10) rem 10 = 6) THEN
							state1 <= STATE_60;
						END IF;
					when STATE_60 =>
						A1 <= '0';
						B10 <= '1';
						C1 <= '0';
						D1 <= '0';
						E1 <= '0';
						F1 <= '0';
						G10 <= '0';
						IF ((moves/10) rem 10 = 7) THEN
							state1 <= STATE_70;
						END IF;
					when STATE_70 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '0';
						D1 <= '1';
						E1 <= '1';
						F1 <= '1';
						G10 <= '1';
						IF ((moves/10) rem 10 = 8) THEN
							state1 <= STATE_80;
						END IF;
					when STATE_80 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '0';
						D1 <= '0';
						E1 <= '0';
						F1 <= '0';
						G10 <= '0';
						IF ((moves/10) rem 10 = 9) THEN
							state1 <= STATE_90;
						END IF;
					when STATE_90 =>
						A1 <= '0';
						B10 <= '0';
						C1 <= '0';
						D1 <= '1';
						E1 <= '1';
						F1 <= '0';
						G10 <= '0';
						IF ((moves/10) rem 10 = 0) THEN
							state1 <= STATE_00;
						END IF;
					when others => null;
				END CASE;
	END IF;
	END PROCESS DISPLAYMOVES1;
	DISPLAYMOVES2 : PROCESS(clk_1, moves)
	BEGIN
	if (clk_1'event and clk_1 = '1') then
				case state2 is
					when STATE_000 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '0';
						D2 <= '0';
						E2 <= '0';
						F2 <= '0';
						G20 <= '1';
						IF ((moves/100) rem 10 = 1) THEN
							state2 <= STATE_100;
						END IF;
					when STATE_100 =>
						A2 <= '1';
						B20 <= '0';
						C2 <= '0';
						D2 <= '1';
						E2 <= '1';
						F2 <= '1';
						G20 <= '1';
						IF ((moves/100) rem 10 = 2) THEN
							state2 <= STATE_200;
						END IF;
					when STATE_200 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '1';
						D2 <= '0';
						E2 <= '0';
						F2 <= '1';
						G20 <= '0';
						IF ((moves/100) rem 10 = 3) THEN
							state2 <= STATE_300;
						END IF;
					when STATE_300 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '0';
						D2 <= '0';
						E2 <= '1';
						F2 <= '1';
						G20 <= '0';
						IF ((moves/100) rem 10 = 4) THEN
							state2 <= STATE_400;
						END IF;
					when STATE_400 =>
						A2 <= '1';
						B20 <= '0';
						C2 <= '0';
						D2 <= '1';
						E2 <= '1';
						F2 <= '0';
						G20 <= '0';
						IF ((moves/100) rem 10 = 5) THEN
							state2 <= STATE_500;
						END IF;
					when STATE_500 =>
						A2 <= '0';
						B20 <= '1';
						C2 <= '0';
						D2 <= '0';
						E2 <= '1';
						F2 <= '0';
						G20 <= '0';
						IF ((moves/100) rem 10 = 6) THEN
							state2 <= STATE_600;
						END IF;
					when STATE_600 =>
						A2 <= '0';
						B20 <= '1';
						C2 <= '0';
						D2 <= '0';
						E2 <= '0';
						F2 <= '0';
						G20 <= '0';
						IF ((moves/100) rem 10 = 7) THEN
							state2 <= STATE_700;
						END IF;
					when STATE_700 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '0';
						D2 <= '1';
						E2 <= '1';
						F2 <= '1';
						G20 <= '1';
						IF ((moves/100) rem 10 = 8) THEN
							state2 <= STATE_800;
						END IF;
					when STATE_800 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '0';
						D2 <= '0';
						E2 <= '0';
						F2 <= '0';
						G20 <= '0';
						IF ((moves/100) rem 10 = 9) THEN
							state2 <= STATE_900;
						END IF;
					when STATE_900 =>
						A2 <= '0';
						B20 <= '0';
						C2 <= '0';
						D2 <= '1';
						E2 <= '1';
						F2 <= '0';
						G20 <= '0';
						IF ((moves/100) rem 10 = 0) THEN
							state2 <= STATE_000;
						END IF;
					when others => null;
				END CASE;
	END IF;
	END PROCESS DISPLAYMOVES2;
	GETNEWPOSITION : PROCESS(clk_1, counter, up, down, l, r, black, bl, re, blue2, pink, gr, turq, yellow, white)
	BEGIN
	IF(clk_1'event and clk_1='1') THEN
		counter <= counter + 1;
	IF(counter = "1011111010111100001000000")THEN
	counter <= (others => '0');
		IF(up = '0') THEN
			IF(black = bl + 3) THEN
				black 	<= black - 3;
				bl			<= bl + 3;
				moves 	<= moves + 1;
			ELSIF(black = re + 3) THEN
				black 	<= black - 3;
				re			<= re + 3;
				moves 	<= moves + 1;
			ELSIF(black = blue2 + 3) THEN
				black 	<= black - 3;
				blue2		<= blue2 + 3;
				moves 	<= moves + 1;
			ELSIF(black = pink + 3) THEN
				black 	<= black - 3;
				pink		<= pink + 3;
				moves 	<= moves + 1;
			ELSIF(black = gr + 3) THEN
				black 	<= black - 3;
				gr			<= gr + 3;
				moves 	<= moves + 1;
			ELSIF(black = turq + 3) THEN
				black 	<= black - 3;
				turq		<= turq + 3;
				moves 	<= moves + 1;
			ELSIF(black = yellow + 3) THEN
				black 	<= black - 3;
				yellow	<= yellow + 3;
				moves 	<= moves + 1;
			ELSIF(black = white + 3) THEN
				black 	<= black - 3;
				white		<= white + 3;
				moves 	<= moves + 1;
			END IF;
		ELSIF(down = '0') THEN
			IF(black = bl - 3) THEN
				black 	<= black + 3;
				bl			<= bl - 3;
				moves 	<= moves + 1;
			ELSIF(black = re - 3) THEN
				black 	<= black + 3;
				re			<= re - 3;
				moves 	<= moves + 1;
			ELSIF(black = blue2 - 3) THEN
				black 	<= black + 3;
				blue2		<= blue2 - 3;
				moves 	<= moves + 1;
			ELSIF(black = pink - 3) THEN
				black 	<= black + 3;
				pink		<= pink - 3;
				moves 	<= moves + 1;
			ELSIF(black = gr - 3) THEN
				black 	<= black + 3;
				gr			<= gr - 3;
				moves 	<= moves + 1;
			ELSIF(black = turq - 3) THEN
				black 	<= black + 3;
				turq		<= turq - 3;
				moves 	<= moves + 1;
			ELSIF(black = yellow - 3) THEN
				black 	<= black + 3;
				yellow	<= yellow - 3;
				moves 	<= moves + 1;
			ELSIF(black = white - 3) THEN
				black 	<= black + 3;
				white		<= white - 3;
				moves 	<= moves + 1;
			END IF;
		ELSIF(l = '0') THEN
			IF(black = bl + 1 and bl /= 2 and bl /= 5) THEN
				black 	<= black - 1;
				bl			<= bl + 1;
				moves 	<= moves + 1;
			ELSIF(black = re + 1 and re /= 2 and re /= 5) THEN
				black 	<= black - 1;
				re			<= re + 1;
				moves 	<= moves + 1;
			ELSIF(black = blue2 + 1 and blue2 /= 2 and blue2 /= 5) THEN
				black 	<= black - 1;
				blue2		<= blue2 + 1;
				moves 	<= moves + 1;
			ELSIF(black = pink + 1 and pink /= 2 and pink /= 5) THEN
				black 	<= black - 1;
				pink		<= pink + 1;
				moves 	<= moves + 1;
			ELSIF(black = gr + 1 and gr /= 2 and gr /= 5) THEN
				black 	<= black - 1;
				gr			<= gr + 1;
				moves 	<= moves + 1;
			ELSIF(black = turq + 1 and turq /= 2 and turq /= 5) THEN
				black 	<= black - 1;
				turq		<= turq + 1;
				moves 	<= moves + 1;
			ELSIF(black = yellow + 1 and yellow /= 2 and yellow /= 5) THEN
				black 	<= black - 1;
				yellow	<= yellow + 1;
				moves 	<= moves + 1;
			ELSIF(black = white + 1 and white /= 2 and white /= 5) THEN
				black 	<= black - 1;
				white		<= white + 1;
				moves 	<= moves + 1;
			END IF;
		ELSIF(r = '0') THEN
			IF(black = bl - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				bl			<= bl - 1;
				moves 	<= moves + 1;
			ELSIF(black = re - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				re			<= re - 1;
				moves 	<= moves + 1;
			ELSIF(black = blue2 - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				blue2		<= blue2 - 1;
				moves 	<= moves + 1;
			ELSIF(black = pink - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				pink		<= pink - 1;
				moves 	<= moves + 1;
			ELSIF(black = gr - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				gr			<= gr - 1;
				moves 	<= moves + 1;
			ELSIF(black = turq - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				turq		<= turq - 1;
				moves 	<= moves + 1;
			ELSIF(black = yellow - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				yellow	<= yellow - 1;
				moves 	<= moves + 1;
			ELSIF(black = white - 1 and black /= 2 and black /= 5) THEN
				black 	<= black + 1;
				white		<= white - 1;
				moves 	<= moves + 1;
			END IF;
		END IF;
		END IF;
	END IF;
	END PROCESS GETNEWPOSITION;
	SETCOLOR : PROCESS(disp_ena, row, column, s, R0, R1, R2, R3, R4, R5, R6, R7, R8, G0, G1, G2, G3, G4, G5, G6, G7, G8, B0, B1, B2, B3, B4, B5, B6, B7, B8)
	BEGIN
		IF(disp_ena = '1') THEN		--display time
			IF(s = '0') THEN
				IF(row < pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => R0);
					green	<= (OTHERS => G0);
					blue <= (OTHERS => B0);
				ELSIF (row < 2*pixels_y AND row > pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => R1);
					green	<= (OTHERS => G1);
					blue <= (OTHERS => B1);
				ELSIF (row < 3*pixels_y AND row > 2*pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => R2);
					green	<= (OTHERS => G2);
					blue <= (OTHERS => B2);
				ELSIF (row < pixels_y AND column < 2*pixels_x AND column > pixels_x) THEN
					red <= (OTHERS => R3);
					green	<= (OTHERS => G3);
					blue <= (OTHERS => B3);
				ELSIF (column < 2*pixels_x AND column > pixels_x AND row < 2*pixels_y AND row > pixels_y) THEN
					red <= (OTHERS => R4);
					green	<= (OTHERS => G4);
					blue <= (OTHERS => B4);
				ELSIF (column < 2*pixels_x AND column > pixels_x AND row < 3*pixels_y AND row > 2*pixels_y) THEN
					red <= (OTHERS => R5);
					green	<= (OTHERS => G5);
					blue <= (OTHERS => B5);
				ELSIF (row < pixels_y AND column < 3*pixels_x AND column > 2*pixels_x) THEN
					red <= (OTHERS => R6);
					green	<= (OTHERS => G6);
					blue <= (OTHERS => B6);
				ELSIF (column < 3*pixels_x AND column > 2*pixels_x AND row < 2*pixels_y AND row > pixels_y) THEN
					red <= (OTHERS => R7);
					green	<= (OTHERS => G7);
					blue <= (OTHERS => B7);
				ELSIF (column < 3*pixels_x AND column > 2*pixels_x AND row < 3*pixels_y AND row > 2*pixels_y) THEN
					red <= (OTHERS => R8);
					green	<= (OTHERS => G8);
					blue <= (OTHERS => B8);
				ELSE
					red 		<= 	(OTHERS => 		'0');
					green 	<= 	(OTHERS => 		'0');
					blue		<= 	(OTHERS => 		'0');
				END IF;
			ELSIF(s = '1') THEN
				IF(row < pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => '0');
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '0');
				ELSIF (row < 2*pixels_y AND row > pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => '0');
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '1');
				ELSIF (row < 3*pixels_y AND row > 2*pixels_y AND column < pixels_x) THEN
					red <= (OTHERS => '0');
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '1');
				ELSIF (row < pixels_y AND column < 2*pixels_x AND column > pixels_x) THEN
					red <= (OTHERS => '0');
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '0');
				ELSIF (column < 2*pixels_x AND column > pixels_x AND row < 2*pixels_y AND row > pixels_y) THEN
					red <= (OTHERS => '0');
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '1');
				ELSIF (column < 2*pixels_x AND column > pixels_x AND row < 3*pixels_y AND row > 2*pixels_y) THEN
					red <= (OTHERS => '1');
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '0');
				ELSIF (row < pixels_y AND column < 3*pixels_x AND column > 2*pixels_x) THEN
					red <= (OTHERS => '1');
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '1');
				ELSIF (column < 3*pixels_x AND column > 2*pixels_x AND row < 2*pixels_y AND row > pixels_y) THEN
					red <= (OTHERS => '1');
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '0');
				ELSIF (column < 3*pixels_x AND column > 2*pixels_x AND row < 3*pixels_y AND row > 2*pixels_y) THEN
					red <= (OTHERS => '1');
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '1');
				ELSE
					red 		<= 	(OTHERS => 		'0');
					green 	<= 	(OTHERS => 		'0');
					blue		<= 	(OTHERS => 		'0');
				END IF;
			END IF;
		ELSE								--blanking time
			red 	<= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue 	<= (OTHERS => '0');
		END IF;
	
	END PROCESS SETCOLOR;
END behavior;