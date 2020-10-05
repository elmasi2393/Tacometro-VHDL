----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional San Francisco
-- Engineer: Rinaudo, Facundo. Gatto, Maximiliano. Lenta, Maximiliano.
-- 
-- Create Date:    02/10/2020 
-- Design Name:    Técnicas Digitales I. Trabajo Práctico N°4
-- Module Name:    Activador del decodificador 
-- Project Name: 	 Tacometro
-- Description:    Su funcion es otorgarle el pulso,en un momento justo, para que
--						 la señal proveniente del contador de vueltas sea decodificada
--						 de binario a BCD.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rst_Decodificador is
    Port ( Ck : in  STD_LOGIC;
           Rst : inout  STD_LOGIC);
end Rst_Decodificador;

architecture Behavioral of Rst_Decodificador is
	constant clockFPGA: natural := 100000000; 			--Clock de la FPGA - 100MHz
	constant clockPulso: natural := 1; 					   --Cada cuento saca un pulso
	signal contador: natural := 0;
begin
	pulsoRst: process (Ck)
	begin
		if Ck = '1' and Ck 'EVENT then
			if contador = ((clockFPGA/clockPulso)-1) then --Si se contaron los pulsos necesarios
				contador <= 0;								  		--Se resetea el contador
				Rst <= '1';									  		--Y se pone en alto la salida
			else
				contador <= contador + 1;				  --Sino se incrementa el contador
				Rst <= '0';									  --Permaneciendo la salida en bajo
			end if;
		end if;
	end process pulsoRst;

end Behavioral;

