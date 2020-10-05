----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional San Francisco
-- Engineer: Rinaudo, Facundo. Gatto, Maximiliano. Lenta, Maximiliano.
-- 
-- Create Date:    02/10/2020 
-- Design Name:    Técnicas Digitales I. Trabajo Práctico N°4
-- Module Name:    Generador de pulsos - Frecuencias de prueba 
-- Project Name: 	 Tacometro
-- Description:    Nos permite variar la frecuencia de salida por medio de dos
--						 pulsadores, siendo la frecuencia minima de 40Hz y la maxima
--						 de 250Hz, lo que se traduce a 400RPM a 2500RPM ya que estos
--						 pulsos estan conectadas en la entrada denominada Sensor.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity generadorPulsos is
    Port ( pulsadores : in  STD_LOGIC_VECTOR(1 downto 0);
		   Ck: in STD_LOGIC;
		   pulsoSalida: inout STD_LOGIC := '0'
           );
end generadorPulsos;

architecture Behavioral of generadorPulsos is
--Componente
COMPONENT monoestableAntirebotes IS
	Port ( pulso_IN : in  STD_LOGIC;
		   Ck: in STD_LOGIC;
           pulso_OUT : inout  STD_LOGIC := '0');
END COMPONENT;
--Señales
signal pAntiRebotes: STD_LOGIC_VECTOR(1 downto 0) := "00";
signal detectaPulso: STD_LOGIC := '0';

signal selectorFrecuencia: STD_LOGIC_VECTOR(2 downto 0) := "000";
signal pulsos_clockSaliente: NATURAL range 0 to 50000000;
signal contador: natural := 0;
 
begin
	--Antirebotes de los pulsadores
	antirebotesAscendente: monoestableAntirebotes PORT MAP(pulsadores(0), Ck , pAntiRebotes(0));
	antirebotesDescendente: monoestableAntirebotes PORT MAP(pulsadores(1), Ck , pAntiRebotes(1));
	
	--Deteccion de un pulso
	detectaPulso <= (pAntiRebotes(0) XOR pAntiRebotes(1));
	
	--Divisor de frecuencia
	DDF: process(Ck)
	begin
		if Ck = '1' and Ck 'EVENT then --Clock en 1
			if contador >= pulsos_clockSaliente then  --Si llego al numero de ciclos deseados
				contador <= 1;									--Reseteamos el contador
				pulsoSalida <= not pulsoSalida;			--Invertimos la salida
			else
				contador <= contador + 1; --Incrementamos el contador
			end if;
		end if;
	end process DDF;
	
	--Ajuste de Frecuencia
	ajuste:process(detectaPulso)
	begin
	if detectaPulso = '1' and detectaPulso 'EVENT then
		case pAntiRebotes is
			when "01" => 
			             if selectorFrecuencia < "111" then							--Si no llego al maximo
			                 selectorFrecuencia <= selectorFrecuencia + '1';	--Incrementamos
			             end if;
			when others => 
			             if selectorFrecuencia > "000" then							--Si no llego al minimo
			                 selectorFrecuencia <= selectorFrecuencia - '1';	--Decrementamos
			             end if;
		end case;
	end if;	
	end process ajuste;
	
	--Selecciona la cantidad de pulsos necesarias para llegar a esa frecuencia
	WITH selectorFrecuencia SELECT
		        pulsos_clockSaliente <= 1250000 WHEN "000",   --40Hz
												  714286 WHEN "001",    --70Hz
												  500000 WHEN "010",    --100Hz
												  384615 WHEN "011",    --130Hz
												  312500 WHEN "100",    --160Hz
												  263158 WHEN "101",    --190Hz
												  227273 WHEN "110",    --220Hz
												  200000 WHEN "111",    --250Hz
												  1250000 WHEN OTHERS; --Vuelve a 40Hz por defecto
end Behavioral;

