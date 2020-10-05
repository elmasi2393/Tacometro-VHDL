----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional San Francisco
-- Engineer: Rinaudo, Facundo. Gatto, Maximiliano. Lenta, Maximiliano.
-- 
-- Create Date:    02/10/2020 
-- Design Name:    Técnicas Digitales I. Trabajo Práctico N°4
-- Module Name:    Monoestable Antirebotes
-- Project Name: 	 Tacometro
-- Description:    Se encarga de eliminar el ruido en la señal de entrada, 
--						 proveniente de pulsadores, y en su salida tenemos un pulso
--						 limpio

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity monoestableAntirebotes is
    Port ( pulso_IN : in  STD_LOGIC;
			  Ck: in STD_LOGIC;
           pulso_OUT : inout  STD_LOGIC := '0');
end monoestableAntirebotes;

architecture Behavioral of monoestableAntirebotes is
	--Constantes de ajuste
	constant tiempoAntirebotes: NATURAL := 10; 											--Tiempo en ms
	constant frecuenciaClock: NATURAL  := 100;	 										--Frecuencia en MHz
	constant pulsosClock: NATURAL  := (tiempoAntirebotes*frecuenciaClock*1000);--Numero de pulsos necesarios
	--Señales de programa
	signal estadoAnterior: STD_LOGIC := '0';
	signal contador: NATURAL := 0;

begin
	tiempoEspera: process(Ck)
	begin
		if Ck = '1' and Ck 'EVENT then						--Se evalua en cada pulso de reloj
			if (pulso_IN XOR estadoAnterior) = '1' then	--Si los estados son diferentes se resetea el contador
				contador <= 0;
				estadoAnterior <= pulso_IN;
			elsif contador < pulsosClock then				--Si el contador no llego a su limite se sigue sumando
				contador <= contador + 1;
			else														--Si ya se llego al maximo podemos asegurar el estado del pulsador
				pulso_OUT <= pulso_IN;
			end if;
		end if;
	end process tiempoEspera;
	
end Behavioral;

