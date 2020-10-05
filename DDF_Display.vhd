----------------------------------------------------------------------------------
-- Module Name:    Refresco de Display 
-- Project Name:   Tacometro
-- Description:    Trabaja conjunto al multiplexor, y es el que se encarga de
--						 de enviarle un tren de pulsos para que el multiplexor funcione
--						 pero a una frecuencia inferior que el clock de la placa, ambas
--						 especificadas en las constantes clockFPGA (clock de la placa) y
--						 clockSaliente(clock de salida del bloque)

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

entity DDF_Display is
    Port ( Ck_in : in  STD_LOGIC;
           Ck_out : inout  STD_LOGIC := '0');
end DDF_Display;

architecture Behavioral of DDF_Display is

constant clockFPGA: natural := 100000000; 			--Clock de la FPGA - 100MHz
constant clockSaliente: natural := 2400; 				--Clock saliente en Hz - 2400Hz
signal contador: natural := 0; 

begin
	--Dividimos el numero de ciclos que tiene el clock incorporado por la frecuencia deseada, pero eso nos daria la cantidad
	-- de ciclos que tendria que hacer el clock de la FPGA para realizar solamente medio ciclo del clockSaliente (o un pulso),pero 
	--lo que queremos es que en esa cantidad de pulsos el clock realice un ciclo completo, por ende dividimoo por 2 el resultado de
	--la operacion
	
	Ck_lento: process(Ck_in)
	begin
		if Ck_in = '1' and Ck_in 'EVENT then --Clock en 1
			if contador = (clockFPGA/(2*clockSaliente)) then  --Si llego al numero de ciclos deseados para hacer medio ciclo
				contador <= 1;
				Ck_out <= not Ck_out;
			else
				contador <= contador + 1; --Incrementamos el contador
			end if;
		end if;
	end process;

end Behavioral;

