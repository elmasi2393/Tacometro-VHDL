----------------------------------------------------------------------------------
-- Module Name:    Decodificador 
-- Project Name:   Tacometro
-- Description:    Es el bloque que se encarga de transformar la señal recibida del
--						 contador de vueltas, en binario, y transformarla a BCD por medio
--						 del algortimo doubble dable.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decodificador is
    Port ( Entrada : in  STD_LOGIC_VECTOR (11 downto 0);
           Ck : in  STD_LOGIC;
           Salida : out  STD_LOGIC_VECTOR (15 downto 0):= X"0000");
end Decodificador;

architecture DoubbleDable of Decodificador is

begin
	conversion:process (Ck)
	
		--Variables de registro
		variable conversionParcial: STD_LOGIC_VECTOR(15 DOWNTO 0):= X"0000";	
		variable mensajeCompleto: STD_LOGIC_VECTOR(11 DOWNTO 0):= X"000";
		
	begin
	if Ck = '1' and Ck 'EVENT then
	
		conversionParcial := X"0000";
		
		mensajeCompleto := Entrada;	--Le asignamos la entrada						
		conversionParcial(2 downto 0) := mensajeCompleto(11 downto 9);	--Asignamos los 3 bits MSB del mensaje a la variable
		
		desplazamiento: for i in 0 to 8 loop	--Se repite la cantidad de bits que quedan desplazar (12 - 3 = 9)
		
			--Operacion de comparo y sumo 3
			--Primeros 4bits
			if conversionParcial(3 downto 0) > 4 then
				conversionParcial(3 downto 0) := conversionParcial(3 downto 0) + 3;
			end if;
			--Segundos 4bits
			if conversionParcial(7 downto 4) > 4 then
				conversionParcial(7 downto 4) := conversionParcial(7 downto 4) + 3;
			end if;
			--Terceros 4bits
			if conversionParcial(11 downto 8) > 4 then
				conversionParcial(11 downto 8) := conversionParcial(11 downto 8) + 3;
			end if;
			--No es necesario hacer en los cuatro bits superiores ya que la ultima iteracion es la 
			--que puede hacer que el numero del nible superior podria ser mayor a 4, por lo tanto no 
			--se reajusta, ademas de que para un numero de 12 bit binarios no puede ser mayor a 5
		
			--Desplazamiento
			conversionParcial := conversionParcial(14 downto 0) & mensajeCompleto(8-i); --Se asigna el siguiente bit
		
		
		end loop desplazamiento;
		
		--Asignamos la salida
		Salida <= conversionParcial;
	end if;
	end process;
end DoubbleDable;

