----------------------------------------------------------------------------------
-- Module Name:    Contador de vueltas
-- Project Name: 	 Tacometro
-- Description:    Se encarga de contar la cantidad de pulsos que se envian del
--						 sensor y transformarlos a RPM. Cabe aclarar que esta cuenta
-- 					 es en binario.

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

entity cuentaVueltas is
    Port ( Sensor : inout  STD_LOGIC;
		   Rst: in STD_LOGIC;
           RPM : out  STD_LOGIC_VECTOR (11 downto 0):= X"000");
end cuentaVueltas;

architecture Behavioral of cuentaVueltas is
	--SEÑALES
	signal cuentaVueltas: NATURAL range 0 to 4095;	--Señal de contador de vueltas
	
begin	
	vuelta:PROCESS (Rst, Sensor)
	begin
		 if Rst = '1' then	--Reset
			cuentaVueltas <= 0;
			
		 elsif Sensor = '1' and Sensor 'EVENT then --Señal del sensor
			cuentaVueltas <= cuentaVueltas + 10;    --Incrementamos las RPM
		 end if;
	end process Vuelta;
	
	--Salida a Decodificador
	RPM <= CONV_STD_LOGIC_VECTOR(cuentaVueltas , 12);
	
end Behavioral;

