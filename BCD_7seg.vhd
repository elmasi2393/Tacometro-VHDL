----------------------------------------------------------------------------------
-- Module Name:    Decodificador BCD a 7 segmentos 
-- Project Name: 	 Tacometro
-- Description:    Convierte la señal de codigo BCD a unsa salida que asigne el
--		   estado necesario a cada segmento del display 7 segmentos, con
--		   configuracion de anodo comun.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_7seg is
    Port ( Entrada_BCD : in  STD_LOGIC_VECTOR (3 downto 0);
           Salida_7seg : out  STD_LOGIC_VECTOR (6 downto 0));
end BCD_7seg;

architecture Behavioral of BCD_7seg is

begin
	with Entrada_BCD SELECT
							--  abcdefg
		Salida_7seg <= not"1111110" WHEN X"0", -- 0
							not"0110000" WHEN X"1", -- 1
							not"1101101" WHEN X"2", -- 2
							not"1111001" WHEN X"3", -- 3
							not"0110011" WHEN X"4", -- 4
							not"1011011" WHEN X"5", -- 5
							not"0011111" WHEN X"6", -- 6
							not"1110000" WHEN X"7", -- 7
							not"1111111" WHEN X"8", -- 8
							not"1110011" WHEN X"9", -- 9
							not"0000000" WHEN OTHERS; --En caso de no cumplirse ninguno
							--Negados por ser anodo comun
end Behavioral;

