-- Translation of QBUSEMUDMA.PLD (GPL-3.0-or-later).
-- Original design: Copyright (C) 2025 Peter Schranz.
-- Equations retain the CUPL compiler expansion, clocks, enables, preset/reset
-- and state encoding. No power-up initialization has been added.
-- Source SHA256: d3974cf0758cf611842791a5b2bf757fe2396731004fe1d568008eacdc414bf1
--PIN: CHIP "QBUSEMUDMA" ASSIGNED TO AN TQFP44
--PIN: TSYNC : 21
--PIN: RSYNC : 11
--PIN: TWTBT : 18
--PIN: RINIT : 12
--PIN: TDIN : 20
--PIN: TDOUT : 10
--PIN: RRPLY : 22
--PIN: RDMGI : 14
--PIN: TDMGO : 13
--PIN: TDMR : 15
--PIN: TSACK : 8
--PIN: RREF : 23
--PIN: TBS7 : 25
--PIN: REF : 27
--PIN: CLK : 37
--PIN: ABO : 35
--PIN: DMR : 34
--PIN: DMG : 30
--PIN: DMARD : 3
--PIN: LD : 5
--PIN: TADDR : 6
--AUTO-PIN: DMA0
--AUTO-PIN: DMA1
--AUTO-PIN: DMA2
--AUTO-PIN: DMA3
library ieee;
use ieee.std_logic_1164.all;

entity QBUSEMUDMA is
  port (
    TSYNC : out std_logic;
    RSYNC : in std_logic;
    TWTBT : out std_logic;
    RINIT : in std_logic;
    TDIN : out std_logic;
    TDOUT : out std_logic;
    RRPLY : in std_logic;
    RDMGI : in std_logic;
    TDMGO : out std_logic;
    TDMR : out std_logic;
    TSACK : out std_logic;
    RREF : in std_logic;
    TBS7 : out std_logic;
    REF : out std_logic;
    CLK : in std_logic;
    ABO : in std_logic;
    DMR : in std_logic;
    DMG : out std_logic;
    DMARD : in std_logic;
    LD : out std_logic;
    TADDR : out std_logic;
    DMA0 : out std_logic;
    DMA1 : out std_logic;
    DMA2 : out std_logic;
    DMA3 : out std_logic
  );
end entity;

architecture rtl of QBUSEMUDMA is
  signal DMA4 : std_logic;
  signal DMA5 : std_logic;
  signal DMA6 : std_logic;
  signal DMGI : std_logic;
  signal DMGIR : std_logic;
  signal RPLY : std_logic;
  signal RPLYR : std_logic;
  signal SYNC : std_logic;
  signal SYNCR : std_logic;
  attribute keep : boolean;
  attribute keep of DMA4, DMA5, DMA6, DMGI, DMGIR, RPLY, RPLYR, SYNC, SYNCR : signal is true;
  component \DFFAR\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFF\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \Q\ : out std_logic);
  end component;
begin
  REF <= (not RREF);
  TBS7 <= ('0');
  TDMGO <= (DMA0 and not DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA5 and not DMA6 and DMGI);
  TSACK <= (DMA5);
  TWTBT <= (not DMARD and TADDR);
  DMA0_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and DMA1 and not DMA2 and DMA5 and not DMA6)
      or (not DMA0 and not DMA1 and not DMA3 and DMA5 and not DMA6)
      or (not DMA0 and not DMA2 and DMA5 and not DMA6 and RPLY)
      or (DMA1 and not DMA2 and DMA3 and DMA5 and not DMA6 and RPLY)
      or (DMA0 and not DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA5 and not DMA6)
      or (not DMA0 and not DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA6 and DMGI and not DMR),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA0);
  DMA1_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and DMA1 and not DMA2 and DMA5 and not DMA6)
      or (DMA0 and not DMA1 and not DMA2 and DMA5 and not DMA6)
      or (DMA0 and not DMA2 and DMA3 and DMA5 and not DMA6 and RPLY)
      or (not DMA0 and not DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA5 and not DMA6 and DMGI and DMR),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA1);
  DMA2_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and not DMA1 and DMA2 and not DMA3 and DMA5 and not DMA6)
      or (DMA0 and DMA1 and not DMA2 and not DMA3 and DMA5 and not DMA6)
      or (DMA0 and DMA1 and not DMA2 and DMA5 and not DMA6 and not RPLY),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA2);
  DMA3_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA2 and DMA3 and DMA5 and not DMA6) or (DMA0 and not DMA1 and DMA2 and not DMA3 and DMA5 and not DMA6),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA3);
  DMA4_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA2 and DMA4 and DMA5 and not DMA6)
      or (not DMA1 and not DMA3 and DMA4 and DMA5 and not DMA6)
      or (not DMA0 and not DMA1 and DMA2 and DMA3 and DMA5 and not DMA6)
      or (not DMA0 and not DMA1 and not DMA2 and not DMA3 and DMA4 and not DMA6 and DMR)
      or (not DMA0 and DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA5 and not DMA6 and DMARD),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA4);
  DMA5_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA2 and DMA5 and not DMA6)
      or (not DMA1 and not DMA3 and DMA5 and not DMA6)
      or (not DMA0 and DMA1 and not DMA2 and not DMA3 and not DMA4 and not DMA6),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA5);
  DMA6_register: \DFFAR\ port map (
    \CLK\ => (CLK),
    \D\ => ('0'),
    \AR\ => (RINIT) or (ABO),
    \Q\ => DMA6);
  DMG_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and not DMA1 and DMA2 and DMA3 and DMA5 and not DMA6)
      or (not DMA0 and not DMA1 and not DMA2 and not DMA3 and DMA4 and not DMA5 and not DMA6 and DMR),
    \Q\ => DMG);
  DMGI_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (DMGIR),
    \Q\ => DMGI);
  DMGIR_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RDMGI),
    \Q\ => DMGIR);
  LD_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (DMA0 and not DMA1 and not DMA2 and DMA3 and DMA4 and DMA5 and not DMA6)
      or (not DMA1 and not DMA2 and DMA3 and DMA4 and DMA5 and not DMA6 and RPLY),
    \Q\ => LD);
  RPLY_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RPLYR),
    \Q\ => RPLY);
  RPLYR_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RRPLY),
    \Q\ => RPLYR);
  SYNC_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (SYNCR),
    \Q\ => SYNC);
  SYNCR_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RSYNC),
    \Q\ => SYNCR);
  TADDR_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA2 and not DMA3 and DMA5 and not DMA6) or (not DMA0 and not DMA1 and not DMA3 and DMA5 and not DMA6),
    \Q\ => TADDR);
  TDIN_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and not DMA2 and DMA3 and DMA4 and DMA5 and not DMA6)
      or (not DMA1 and not DMA2 and DMA3 and DMA4 and DMA5 and not DMA6)
      or (DMA0 and not DMA1 and DMA2 and not DMA3 and DMA4 and DMA5 and not DMA6),
    \Q\ => TDIN);
  TDMR_register: \DFFAR\ port map (
    \CLK\ => (DMR),
    \D\ => ('1'),
    \AR\ => (TSACK) or (RINIT) or (ABO),
    \Q\ => TDMR);
  TDOUT_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and not DMA2 and DMA3 and not DMA4 and DMA5 and not DMA6)
      or (not DMA1 and not DMA2 and DMA3 and not DMA4 and DMA5 and not DMA6)
      or (DMA0 and not DMA1 and DMA2 and not DMA3 and not DMA4 and DMA5 and not DMA6),
    \Q\ => TDOUT);
  TSYNC_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (not DMA0 and DMA1 and not DMA2 and DMA5 and not DMA6)
      or (not DMA1 and not DMA2 and DMA3 and DMA5 and not DMA6)
      or (not DMA1 and DMA2 and not DMA3 and DMA5 and not DMA6)
      or (DMA1 and not DMA2 and not DMA3 and DMA5 and not DMA6)
      or (DMA1 and not DMA2 and DMA5 and not DMA6 and RPLY),
    \Q\ => TSYNC);
end architecture;

-- synthesis translate_off
library ieee;
use ieee.std_logic_1164.all;
entity \DFFAR\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFFAR\ is
begin
  process (\CLK\, \AR\)
  begin
    if \AR\ = '1' then \Q\ <= '0';
    elsif rising_edge(\CLK\) then
      \Q\ <= \D\;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity \DFF\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFF\ is
begin
  process (\CLK\)
  begin
    if rising_edge(\CLK\) then
      \Q\ <= \D\;
    end if;
  end process;
end architecture;

-- synthesis translate_on
