----------------------------------------------------------------------------------
-- Module Name:    Multiplexor 
-- Project Name: 	 Tacometro
-- Description:    La funcinalidad del multiplexor es ir variando sus salidas,
--						 tanto digitos como anodos, con la llegada de un pulso de reloj,
--						 enviado por Refresco Display, para poder ser visualizada en
--						 un display 7 segmentos.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplexorBCD is
    Port ( Entrada : in  STD_LOGIC_VECTOR (15 downto 0);
           Ck : in  STD_LOGIC;
			  Display : out  STD_LOGIC_VECTOR (6 downto 0);
           Anodos : out  STD_LOGIC_VECTOR (3 downto 0));
end multiplexorBCD;

architecture Behavioral of multiplexorBCD is

--COMPONENTE
--Deco BCD - 7Seg
	COMPONENT BCD_7Seg IS
	Port ( Entrada_BCD : in  STD_LOGIC_VECTOR (3 downto 0);
          Salida_7seg : out  STD_LOGIC_VECTOR (6 downto 0));
	END COMPONENT;
	
--SEÑALES
signal cont: INTEGER range 0 to 15 := 15;
signal digitoBCD: STD_LOGIC_VECTOR(3 downto 0);


begin
	--Posiciones de numeros en vector enrada
	-- U. de mil		Centena		Decena	 Unidad
	--15 14 13 12    11 10 9 8    7 6 5 4   3 2 1 0 
	
	multiplexor:process (Ck)
	begin
		if Ck = '1' and Ck 'EVENT then --Cada vez que se llegue señal de clock
			--Selector de digito
			if cont = 3 then
				cont <= 15;		 --Volvemos al nibble inicial
			else
				cont <= cont-4; --Pasamos al siguiente nibble
			end if;
		end if;
	end process;
	
	--Asignamos la salida
	digitoBCD <= Entrada(cont downto cont-3);					--Almacenamos el numero que queremos mostrar en este instante
	decoBCD_7seg: BCD_7seg PORT MAP(digitoBCD, Display);	--y lo decodificamos a salida de 7 segmentos
	
	--Asignamos los anodos
	with cont SELECT
		Anodos <= not"1000" WHEN 15, --U. de mil
					 not"0100" WHEN 11, --Centena
					 not"0010" WHEN 7,  --Decena
				    not"0001" WHEN 3,  -- Unidad
					 not"0000" WHEN OTHERS; --Defecto
	--Negados por ser anodo comun
end Behavioral;

