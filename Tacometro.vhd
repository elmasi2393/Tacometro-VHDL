----------------------------------------------------------------------------------
-- Module Name:    Tacometro - Bloque general 
-- Project Name: 	 Tacometro
-- Description:    Bloque general del tacometro, en el cual se engloban los demas
--		   bloques que se utilizan para el funcionamiento del mismo, incluido
--		   un circuito que nos permite probarlo.

-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Tacometro is
    Port ( Sensor : inout  STD_LOGIC;
           pulsadores : in  STD_LOGIC_VECTOR(1 downto 0);
           Ck : in  STD_LOGIC;
           Pulsos: inout STD_LOGIC := '0';
		     salPrueba: out STD_LOGIC_VECTOR(11 downto 0);
           Digitos : out  STD_LOGIC_VECTOR (6 downto 0);
           Anodos : out  STD_LOGIC_VECTOR (3 downto 0));
end Tacometro;

architecture Behavioral of Tacometro is
----------------COMPONENTES----------------
--GENERADOR DE PULSOS
COMPONENT generadorPulsos IS
Port ( pulsadores : in  STD_LOGIC_VECTOR(1 downto 0);
	   Ck: in STD_LOGIC;
	   pulsoSalida: inout STD_LOGIC := '0'
      );
END COMPONENT;

--AJUSTES DE CLOCK
--Rst de contador de vueltas
COMPONENT Rst_cuentaVueltas IS
	Port ( Ck : in  STD_LOGIC;
           Rst : inout  STD_LOGIC);
END COMPONENT;

--Activador Decodificador
COMPONENT Rst_Decodificador IS
	Port ( Ck : in  STD_LOGIC;
           Rst : inout  STD_LOGIC);
END COMPONENT;

--Refresco de Display
COMPONENT DDF_Display IS
	Port ( Ck_in : in  STD_LOGIC;
          Ck_out : inout  STD_LOGIC := '0');
END COMPONENT;

--BLOQUES
--Cuenta Vueltas
COMPONENT cuentaVueltas IS
	Port ( Sensor : inout  STD_LOGIC;
		    Rst: in STD_LOGIC;
          RPM : out  STD_LOGIC_VECTOR (11 downto 0):= X"000");
END COMPONENT;

--Decodificador BIN-BCD
COMPONENT Decodificador IS
    Port ( Entrada : in  STD_LOGIC_VECTOR (11 downto 0);
           Ck : in  STD_LOGIC;
           Salida : out  STD_LOGIC_VECTOR (15 downto 0));
END COMPONENT;

--Multiplexor
COMPONENT multiplexorBCD IS
Port ( Entrada : in  STD_LOGIC_VECTOR (15 downto 0);
           Ck : in  STD_LOGIC;
           Display : out  STD_LOGIC_VECTOR (6 downto 0);
           Anodos : out  STD_LOGIC_VECTOR (3 downto 0));

END COMPONENT;

----------------SEÑALES----------------
--Interconexiones
signal conexionDeco: STD_LOGIC_VECTOR(11 downto 0):= X"000";
signal conexionMUX: STD_LOGIC_VECTOR(15 downto 0):= X"0000";
--Reset
signal Rst_CV: STD_LOGIC := '0';
signal Rst_Deco: STD_LOGIC := '0';
signal Rst_Dis: STD_LOGIC := '0';

--Prueba
--signal pulsosEntrada: STD_LOGIC := '0';

begin
    --Generador de Pulsos
    genPulsos: generadorPulsos PORT MAP(pulsadores, Ck, Pulsos);
    
	--Ajustes de clock
	Reset_contVts: Rst_cuentaVueltas PORT MAP (Ck ,Rst_CV);
	Activador_deco: Rst_Decodificador PORT MAP (Ck, Rst_Deco);
	Refresco_Display: DDF_Display PORT MAP(Ck, Rst_Dis);
	
	--Componentes
	contadorVueltas: cuentaVueltas PORT MAP(Sensor, Rst_CV, conexionDeco);
	decoBIN_BCD: Decodificador PORT MAP(conexionDeco, Rst_Deco, conexionMUX);
	salidaDisplay: multiplexorBCD PORT MAP(conexionMUX, Rst_Dis, Digitos, Anodos);
	
	--Salida de prueba del contador
	salPrueba <= conexionDeco;
	
end Behavioral;

