-- Translation of QBUSEMUMAIN.PLD (GPL-3.0-or-later).
-- Original design: Copyright (C) 2025 Peter Schranz.
-- Equations retain the CUPL compiler expansion, clocks, enables, preset/reset
-- and state encoding. No power-up initialization has been added.
-- Source SHA256: 803477998ad3a91f803170db44646025fd6354830372869104e0f89ef6236362
--PIN: CHIP "QBUSEMUMAIN" ASSIGNED TO AN TQFP100
--PIN: RDAL0 : 46
--PIN: RDAL1 : 44
--PIN: RDAL2 : 98
--PIN: RDAL3 : 25
--PIN: RDAL4 : 1
--PIN: RDAL5 : 32
--PIN: RDAL6 : 31
--PIN: RDAL7 : 30
--PIN: RDAL8 : 100
--PIN: RDAL9 : 99
--PIN: RDAL10 : 2
--PIN: RDAL11 : 24
--PIN: RDAL12 : 13
--PIN: RDAL13 : 5
--PIN: RDAL14 : 6
--PIN: RDAL15 : 7
--PIN: TDAL0 : 47
--PIN: TDAL1 : 45
--PIN: TDAL2 : 36
--PIN: TDAL3 : 35
--PIN: TDAL4 : 33
--PIN: TDAL5 : 16
--PIN: TDAL6 : 17
--PIN: TDAL7 : 27
--PIN: TDAL8 : 8
--PIN: TDAL9 : 20
--PIN: TDAL10 : 10
--PIN: TDAL11 : 21
--PIN: TDAL12 : 22
--PIN: TDAL13 : 23
--PIN: TDAL14 : 28
--PIN: TDAL15 : 29
--PIN: TDAL16 : 60
--PIN: TDAL17 : 58
--PIN: TDAL18 : 42
--PIN: TDAL19 : 41
--PIN: TDAL20 : 40
--PIN: TDAL21 : 37
--PIN: RSYNC : 54
--PIN: RBS7 : 48
--PIN: RDIN : 55
--PIN: RDOUT : 57
--PIN: RWTBT : 53
--PIN: RINIT : 89
--PIN: RIAKI : 49
--PIN: TRPLY : 56
--PIN: TIAKO : 50
--PIN: TIRQ : 52
--PIN: CLK : 90
--PIN: RD : 88
--PIN: WR : 87
--PIN: AD0 : 97
--PIN: AD1 : 96
--PIN: AD2 : 94
--PIN: AD3 : 93
--PIN: AD4 : 92
--PIN: AD5 : 81
--PIN: AD6 : 80
--PIN: AD7 : 79
--PIN: RS0 : 78
--PIN: RS1 : 77
--PIN: RS2 : 76
--PIN: INTI : 75
--PIN: INTQ : 72
--PIN: ACK : 71
--PIN: CRDY : 70
--PIN: MSCP : 83
--PIN: IRQ : 69
--PIN: DMARD : 68
--PIN: LD : 67
--PIN: TADDR : 65
--PIN: TSACK : 19
--PIN: TDOUT : 61
library ieee;
use ieee.std_logic_1164.all;

entity QBUSEMUMAIN is
  port (
    RDAL0 : in std_logic;
    RDAL1 : in std_logic;
    RDAL2 : in std_logic;
    RDAL3 : in std_logic;
    RDAL4 : in std_logic;
    RDAL5 : in std_logic;
    RDAL6 : in std_logic;
    RDAL7 : in std_logic;
    RDAL8 : in std_logic;
    RDAL9 : in std_logic;
    RDAL10 : in std_logic;
    RDAL11 : in std_logic;
    RDAL12 : in std_logic;
    RDAL13 : in std_logic;
    RDAL14 : in std_logic;
    RDAL15 : in std_logic;
    TDAL0 : out std_logic;
    TDAL1 : out std_logic;
    TDAL2 : out std_logic;
    TDAL3 : out std_logic;
    TDAL4 : out std_logic;
    TDAL5 : out std_logic;
    TDAL6 : out std_logic;
    TDAL7 : out std_logic;
    TDAL8 : out std_logic;
    TDAL9 : out std_logic;
    TDAL10 : out std_logic;
    TDAL11 : out std_logic;
    TDAL12 : out std_logic;
    TDAL13 : out std_logic;
    TDAL14 : out std_logic;
    TDAL15 : out std_logic;
    TDAL16 : out std_logic;
    TDAL17 : out std_logic;
    TDAL18 : out std_logic;
    TDAL19 : out std_logic;
    TDAL20 : out std_logic;
    TDAL21 : out std_logic;
    RSYNC : in std_logic;
    RBS7 : in std_logic;
    RDIN : in std_logic;
    RDOUT : in std_logic;
    RWTBT : in std_logic;
    RINIT : in std_logic;
    RIAKI : in std_logic;
    TRPLY : out std_logic;
    TIAKO : out std_logic;
    TIRQ : out std_logic;
    CLK : in std_logic;
    RD : in std_logic;
    WR : in std_logic;
    AD0 : inout std_logic;
    AD1 : inout std_logic;
    AD2 : inout std_logic;
    AD3 : inout std_logic;
    AD4 : inout std_logic;
    AD5 : inout std_logic;
    AD6 : inout std_logic;
    AD7 : inout std_logic;
    RS0 : in std_logic;
    RS1 : in std_logic;
    RS2 : in std_logic;
    INTI : out std_logic;
    INTQ : out std_logic;
    ACK : in std_logic;
    CRDY : in std_logic;
    MSCP : in std_logic;
    IRQ : in std_logic;
    DMARD : out std_logic;
    LD : in std_logic;
    TADDR : in std_logic;
    TSACK : in std_logic;
    TDOUT : in std_logic
  );
end entity;

architecture rtl of QBUSEMUMAIN is
  signal A1 : std_logic;
  signal A10 : std_logic;
  signal A11 : std_logic;
  signal A12 : std_logic;
  signal A13 : std_logic;
  signal A14 : std_logic;
  signal A15 : std_logic;
  signal A16 : std_logic;
  signal A17 : std_logic;
  signal A18 : std_logic;
  signal A19 : std_logic;
  signal A2 : std_logic;
  signal A20 : std_logic;
  signal A21 : std_logic;
  signal A3 : std_logic;
  signal A4 : std_logic;
  signal A5 : std_logic;
  signal A6 : std_logic;
  signal A7 : std_logic;
  signal A8 : std_logic;
  signal A9 : std_logic;
  signal ALT : std_logic;
  signal C1 : std_logic;
  signal C2 : std_logic;
  signal C3 : std_logic;
  signal C4 : std_logic;
  signal C5 : std_logic;
  signal C6 : std_logic;
  signal CSR : std_logic;
  signal CWTBT : std_logic;
  signal DACK : std_logic;
  signal DD0 : std_logic;
  signal DD1 : std_logic;
  signal DD10 : std_logic;
  signal DD11 : std_logic;
  signal DD12 : std_logic;
  signal DD13 : std_logic;
  signal DD14 : std_logic;
  signal DD15 : std_logic;
  signal DD2 : std_logic;
  signal DD3 : std_logic;
  signal DD4 : std_logic;
  signal DD5 : std_logic;
  signal DD6 : std_logic;
  signal DD7 : std_logic;
  signal DD8 : std_logic;
  signal DD9 : std_logic;
  signal DQ0 : std_logic;
  signal DQ1 : std_logic;
  signal DQ10 : std_logic;
  signal DQ11 : std_logic;
  signal DQ12 : std_logic;
  signal DQ13 : std_logic;
  signal DQ14 : std_logic;
  signal DQ15 : std_logic;
  signal DQ2 : std_logic;
  signal DQ3 : std_logic;
  signal DQ4 : std_logic;
  signal DQ5 : std_logic;
  signal DQ6 : std_logic;
  signal DQ7 : std_logic;
  signal DQ8 : std_logic;
  signal DQ9 : std_logic;
  signal ENA : std_logic;
  signal I14 : std_logic;
  signal I7 : std_logic;
  signal RIAKI1 : std_logic;
  signal RIAKI2 : std_logic;
  signal ROM : std_logic;
  signal ROMEN : std_logic;
  signal TDOUT1 : std_logic;
  signal INTQ_FF : std_logic;
  attribute keep : boolean;
  attribute keep of A1, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A2, A20, A21, A3, A4, A5, A6, A7, A8, A9, ALT, C1, C2, C3, C4, C5, C6, CSR, CWTBT, DACK, DD0, DD1, DD10, DD11, DD12, DD13, DD14, DD15, DD2, DD3, DD4, DD5, DD6, DD7, DD8, DD9, DQ0, DQ1, DQ10, DQ11, DQ12, DQ13, DQ14, DQ15, DQ2, DQ3, DQ4, DQ5, DQ6, DQ7, DQ8, DQ9, ENA, I14, I7, RIAKI1, RIAKI2, ROM, ROMEN, TDOUT1, INTQ_FF : signal is true;
  component \TFFARS\ is
    port (\CLK\ : in std_logic; \T\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFFE\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \CE\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFF\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFFAR\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFFEARS\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \CE\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFFARS\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
  end component;
  component \DFFAS\ is
    port (\CLK\ : in std_logic; \D\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
  end component;
begin
  -- PIN !INTQ in CUPL inverts the logical register at the physical pin.
  INTQ <= not INTQ_FF;
  AD0 <= (CWTBT and not RS0 and not RS1 and RS2)
      or (DD8 and RS0 and RS1 and not RS2)
      or (DD0 and not RS0 and RS1 and not RS2)
      or (RDAL8 and RS0 and not RS1 and not RS2)
      or (RDAL0 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD1 <= (C1 and not RS0 and not RS1 and RS2)
      or (DD9 and RS0 and RS1 and not RS2)
      or (DD1 and not RS0 and RS1 and not RS2)
      or (RDAL9 and RS0 and not RS1 and not RS2)
      or (RDAL1 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD2 <= (C2 and not RS0 and not RS1 and RS2)
      or (DD10 and RS0 and RS1 and not RS2)
      or (DD2 and not RS0 and RS1 and not RS2)
      or (RDAL10 and RS0 and not RS1 and not RS2)
      or (RDAL2 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD3 <= (C3 and not RS0 and not RS1 and RS2)
      or (DD11 and RS0 and RS1 and not RS2)
      or (DD3 and not RS0 and RS1 and not RS2)
      or (RDAL11 and RS0 and not RS1 and not RS2)
      or (RDAL3 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD4 <= (C4 and not RS0 and not RS1 and RS2)
      or (DD12 and RS0 and RS1 and not RS2)
      or (DD4 and not RS0 and RS1 and not RS2)
      or (RDAL12 and RS0 and not RS1 and not RS2)
      or (RDAL4 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD5 <= (C5 and not RS0 and not RS1 and RS2)
      or (DD13 and RS0 and RS1 and not RS2)
      or (DD5 and not RS0 and RS1 and not RS2)
      or (RDAL13 and RS0 and not RS1 and not RS2)
      or (RDAL5 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD6 <= (C6 and not RS0 and not RS1 and RS2)
      or (DD14 and RS0 and RS1 and not RS2)
      or (DD6 and not RS0 and RS1 and not RS2)
      or (RDAL14 and RS0 and not RS1 and not RS2)
      or (RDAL6 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  AD7 <= (ROM and not RS0 and not RS1 and RS2)
      or (DD15 and RS0 and RS1 and not RS2)
      or (DD7 and not RS0 and RS1 and not RS2)
      or (RDAL15 and RS0 and not RS1 and not RS2)
      or (RDAL7 and not RS0 and not RS1 and not RS2) when (RD) = '1' else 'Z';
  I7 <= (A1 and A2 and A3 and A4 and A5 and A6 and A7);
  I14 <= (A8 and A9 and A10 and A11 and A12 and A13 and A14 and I7);
  TDAL0 <= (DD0 and not RIAKI and TDOUT1 and TSACK) or (CSR and DQ0 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL1 <= (A1 and not RIAKI and TADDR and TSACK)
      or (DD1 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ1 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL2 <= (DACK and DQ2 and RIAKI)
      or (A2 and not RIAKI and TADDR and TSACK)
      or (DD2 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ2 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL3 <= (DACK and DQ3 and RIAKI)
      or (A3 and not RIAKI and TADDR and TSACK)
      or (DD3 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ3 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL4 <= (DACK and DQ4 and RIAKI)
      or (A4 and not RIAKI and TADDR and TSACK)
      or (DD4 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ4 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL5 <= (DACK and DQ5 and RIAKI)
      or (A5 and not RIAKI and TADDR and TSACK)
      or (DD5 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ5 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL6 <= (DACK and DQ6 and RIAKI)
      or (A6 and not RIAKI and TADDR and TSACK)
      or (DD6 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ6 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL7 <= (DACK and DQ7 and RIAKI)
      or (A7 and not RIAKI and TADDR and TSACK)
      or (DD7 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ7 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL8 <= (DACK and DQ8 and RIAKI)
      or (A8 and not RIAKI and TADDR and TSACK)
      or (DD8 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ8 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL9 <= (A9 and not RIAKI and TADDR and TSACK)
      or (DD9 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ9 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL10 <= (A10 and not RIAKI and TADDR and TSACK)
      or (DD10 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ10 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL11 <= (A11 and not RIAKI and TADDR and TSACK)
      or (DD11 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ11 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL12 <= (A12 and not RIAKI and TADDR and TSACK)
      or (DD12 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ12 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL13 <= (A13 and not RIAKI and TADDR and TSACK)
      or (DD13 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ13 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL14 <= (A14 and not RIAKI and TADDR and TSACK)
      or (DD14 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ14 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL15 <= (A15 and not RIAKI and TADDR and TSACK)
      or (DD15 and not RIAKI and TDOUT1 and TSACK)
      or (CSR and DQ15 and ENA and RDIN and not RIAKI and not TSACK);
  TDAL16 <= (A16 and not RIAKI and TADDR and TSACK);
  TDAL17 <= (A17 and not RIAKI and TADDR and TSACK);
  TDAL18 <= (A18 and not RIAKI and TADDR and TSACK);
  TDAL19 <= (A19 and not RIAKI and TADDR and TSACK);
  TDAL20 <= (A20 and not RIAKI and TADDR and TSACK);
  TDAL21 <= (A21 and not RIAKI and TADDR and TSACK);
  TIAKO <= (not DACK and RIAKI);
  TIRQ <= (IRQ);
  TRPLY <= (DACK and INTI and RDIN and RIAKI2)
      or (CSR and not INTQ_FF and RDIN and RSYNC)
      or (CSR and not INTQ_FF and RDOUT and RSYNC);
  A1_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => ('1'),
    \AR\ => (not AD1 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD1 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A1);
  A10_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and A9 and I7),
    \AR\ => (not AD2 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD2 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A10);
  A11_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and A9 and A10 and I7),
    \AR\ => (not AD3 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD3 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A11);
  A12_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and A9 and A10 and A11 and I7),
    \AR\ => (not AD4 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD4 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A12);
  A13_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and A9 and A10 and A11 and A12 and I7),
    \AR\ => (not AD5 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD5 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A13);
  A14_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and A9 and A10 and A11 and A12 and A13 and I7),
    \AR\ => (not AD6 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD6 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A14);
  A15_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (I14),
    \AR\ => (not AD7 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD7 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A15);
  A16_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and I14),
    \AR\ => (not AD0 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD0 and RS0 and RS1 and RS2 and WR),
    \Q\ => A16);
  A17_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and A16 and I14),
    \AR\ => (not AD1 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD1 and RS0 and RS1 and RS2 and WR),
    \Q\ => A17);
  A18_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and A16 and A17 and I14),
    \AR\ => (not AD2 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD2 and RS0 and RS1 and RS2 and WR),
    \Q\ => A18);
  A19_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and A16 and A17 and A18 and I14),
    \AR\ => (not AD3 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD3 and RS0 and RS1 and RS2 and WR),
    \Q\ => A19);
  A2_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1),
    \AR\ => (not AD2 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD2 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A2);
  A20_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and A16 and A17 and A18 and A19 and I14),
    \AR\ => (not AD4 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD4 and RS0 and RS1 and RS2 and WR),
    \Q\ => A20);
  A21_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A15 and A16 and A17 and A18 and A19 and A20 and I14),
    \AR\ => (not AD5 and RS0 and RS1 and RS2 and WR),
    \AS\ => (AD5 and RS0 and RS1 and RS2 and WR),
    \Q\ => A21);
  A3_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1 and A2),
    \AR\ => (not AD3 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD3 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A3);
  A4_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1 and A2 and A3),
    \AR\ => (not AD4 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD4 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A4);
  A5_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1 and A2 and A3 and A4),
    \AR\ => (not AD5 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD5 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A5);
  A6_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1 and A2 and A3 and A4 and A5),
    \AR\ => (not AD6 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD6 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A6);
  A7_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A1 and A2 and A3 and A4 and A5 and A6),
    \AR\ => (not AD7 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD7 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => A7);
  A8_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (I7),
    \AR\ => (not AD0 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD0 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A8);
  A9_register: \TFFARS\ port map (
    \CLK\ => (not TSACK),
    \T\ => (A8 and I7),
    \AR\ => (not AD1 and RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD1 and RS0 and not RS1 and RS2 and WR),
    \Q\ => A9);
  ALT_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD1),
    \CE\ => (not RS0 and RS1 and RS2),
    \Q\ => ALT);
  C1_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL1),
    \Q\ => C1);
  C2_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL2),
    \Q\ => C2);
  C3_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL3),
    \Q\ => C3);
  C4_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL4),
    \Q\ => C4);
  C5_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL5),
    \Q\ => C5);
  C6_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RDAL6),
    \Q\ => C6);
  CSR_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RBS7 and not RDAL7 and not RDAL8 and RDAL9 and RDAL10 and not RDAL11 and RDAL12 and ROMEN)
      or (ALT and not MSCP and RBS7 and RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12)
      or (not ALT and not MSCP and RBS7 and not RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12)
      or (not ALT and MSCP and RBS7 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12)
      or (ALT and MSCP and RBS7 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12),
    \Q\ => CSR);
  CWTBT_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RWTBT),
    \Q\ => CWTBT);
  DACK_register: \DFFAR\ port map (
    \CLK\ => (RDIN),
    \D\ => (IRQ),
    \AR\ => (RINIT),
    \Q\ => DACK);
  DD0_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD0),
    \AR\ => (LD and not RDAL0),
    \AS\ => (LD and RDAL0),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD0);
  DD1_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD1),
    \AR\ => (LD and not RDAL1),
    \AS\ => (LD and RDAL1),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD1);
  DD10_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD2),
    \AR\ => (LD and not RDAL10),
    \AS\ => (LD and RDAL10),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD10);
  DD11_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD3),
    \AR\ => (LD and not RDAL11),
    \AS\ => (LD and RDAL11),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD11);
  DD12_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD4),
    \AR\ => (LD and not RDAL12),
    \AS\ => (LD and RDAL12),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD12);
  DD13_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD5),
    \AR\ => (LD and not RDAL13),
    \AS\ => (LD and RDAL13),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD13);
  DD14_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD6),
    \AR\ => (LD and not RDAL14),
    \AS\ => (LD and RDAL14),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD14);
  DD15_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD7),
    \AR\ => (LD and not RDAL15),
    \AS\ => (LD and RDAL15),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD15);
  DD2_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD2),
    \AR\ => (LD and not RDAL2),
    \AS\ => (LD and RDAL2),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD2);
  DD3_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD3),
    \AR\ => (LD and not RDAL3),
    \AS\ => (LD and RDAL3),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD3);
  DD4_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD4),
    \AR\ => (LD and not RDAL4),
    \AS\ => (LD and RDAL4),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD4);
  DD5_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD5),
    \AR\ => (LD and not RDAL5),
    \AS\ => (LD and RDAL5),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD5);
  DD6_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD6),
    \AR\ => (LD and not RDAL6),
    \AS\ => (LD and RDAL6),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD6);
  DD7_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD7),
    \AR\ => (LD and not RDAL7),
    \AS\ => (LD and RDAL7),
    \CE\ => (not RS0 and RS1 and not RS2),
    \Q\ => DD7);
  DD8_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD0),
    \AR\ => (LD and not RDAL8),
    \AS\ => (LD and RDAL8),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD8);
  DD9_register: \DFFEARS\ port map (
    \CLK\ => (WR),
    \D\ => (AD1),
    \AR\ => (LD and not RDAL9),
    \AS\ => (LD and RDAL9),
    \CE\ => (RS0 and RS1 and not RS2),
    \Q\ => DD9);
  DMARD_register: \DFFARS\ port map (
    \CLK\ => ('0'),
    \D\ => ('0'),
    \AR\ => (not AD0 and not RS0 and not RS1 and RS2 and WR),
    \AS\ => (AD0 and not RS0 and not RS1 and RS2 and WR),
    \Q\ => DMARD);
  DQ0_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD0),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ0);
  DQ1_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD1),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ1);
  DQ10_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD2),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ10);
  DQ11_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD3),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ11);
  DQ12_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD4),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ12);
  DQ13_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD5),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ13);
  DQ14_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD6),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ14);
  DQ15_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD7),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ15);
  DQ2_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD2),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ2);
  DQ3_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD3),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ3);
  DQ4_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD4),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ4);
  DQ5_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD5),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ5);
  DQ6_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD6),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ6);
  DQ7_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD7),
    \CE\ => (not RS0 and not RS1 and not RS2),
    \Q\ => DQ7);
  DQ8_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD0),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ8);
  DQ9_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD1),
    \CE\ => (RS0 and not RS1 and not RS2),
    \Q\ => DQ9);
  ENA_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RBS7 and not RDAL7 and not RDAL8 and RDAL9 and RDAL10 and not RDAL11 and RDAL12 and ROMEN and not RWTBT)
      or (ALT and CRDY and not MSCP and RBS7 and RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12 and not RWTBT)
      or (not ALT and CRDY and not MSCP and RBS7 and not RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12 and not RWTBT)
      or (not ALT and CRDY and MSCP and RBS7 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12 and not RWTBT)
      or (not ALT and MSCP and RBS7 and not RDAL1 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12 and not RWTBT)
      or (ALT and CRDY and MSCP and RBS7 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12 and not RWTBT)
      or (ALT and MSCP and RBS7 and not RDAL1 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12 and not RWTBT),
    \Q\ => ENA);
  INTI_register: \DFFAS\ port map (
    \CLK\ => (RIAKI),
    \D\ => (not DACK),
    \AS\ => (ACK),
    \Q\ => INTI);
  INTQ_register: \DFFAR\ port map (
    \CLK\ => (RSYNC),
    \D\ => (RBS7 and not RDAL7 and not RDAL8 and RDAL9 and RDAL10 and not RDAL11 and RDAL12 and ROMEN)
      or (ALT and CRDY and not MSCP and RBS7 and RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12)
      or (not ALT and CRDY and not MSCP and RBS7 and not RDAL4 and not RDAL5 and not RDAL6 and not RDAL7 and RDAL8 and not RDAL9 and not RDAL10 and RDAL11 and RDAL12)
      or (not ALT and CRDY and MSCP and RBS7 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12)
      or (not ALT and MSCP and RBS7 and not RDAL1 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12)
      or (ALT and CRDY and MSCP and RBS7 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12)
      or (ALT and MSCP and RBS7 and not RDAL1 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12)
      or (not ALT and MSCP and RBS7 and not RDAL2 and RDAL3 and not RDAL4 and RDAL5 and RDAL6 and not RDAL7 and not RDAL8 and not RDAL9 and RDAL10 and not RDAL11 and RDAL12 and RWTBT)
      or (ALT and MSCP and RBS7 and RDAL2 and RDAL3 and RDAL4 and not RDAL5 and RDAL6 and RDAL7 and not RDAL8 and not RDAL9 and not RDAL10 and not RDAL11 and not RDAL12 and RWTBT),
    \AR\ => (ACK),
    \Q\ => INTQ_FF);
  RIAKI1_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RIAKI),
    \Q\ => RIAKI1);
  RIAKI2_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (RIAKI1),
    \Q\ => RIAKI2);
  ROM_register: \DFF\ port map (
    \CLK\ => (RSYNC),
    \D\ => (not RDAL7 and not RDAL8 and RDAL9 and RDAL10 and not RDAL11 and RDAL12),
    \Q\ => ROM);
  ROMEN_register: \DFFE\ port map (
    \CLK\ => (WR),
    \D\ => (AD0),
    \CE\ => (not RS0 and RS1 and RS2),
    \Q\ => ROMEN);
  TDOUT1_register: \DFF\ port map (
    \CLK\ => (CLK),
    \D\ => (TDOUT),
    \Q\ => TDOUT1);
end architecture;

-- synthesis translate_off
library ieee;
use ieee.std_logic_1164.all;
entity \TFFARS\ is
  port (\CLK\ : in std_logic; \T\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \TFFARS\ is
begin
  process (\CLK\, \AR\, \AS\)
  begin
    if \AR\ = '1' then \Q\ <= '0';
    elsif \AS\ = '1' then \Q\ <= '1';
    elsif rising_edge(\CLK\) then
      \Q\ <= \Q\ xor \T\;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity \DFFE\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \CE\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFFE\ is
begin
  process (\CLK\)
  begin
    if rising_edge(\CLK\) then
      if \CE\ = '1' then
      \Q\ <= \D\;
      end if;
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
entity \DFFEARS\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \CE\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFFEARS\ is
begin
  process (\CLK\, \AR\, \AS\)
  begin
    if \AR\ = '1' then \Q\ <= '0';
    elsif \AS\ = '1' then \Q\ <= '1';
    elsif rising_edge(\CLK\) then
      if \CE\ = '1' then
      \Q\ <= \D\;
      end if;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity \DFFARS\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \AR\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFFARS\ is
begin
  process (\CLK\, \AR\, \AS\)
  begin
    if \AR\ = '1' then \Q\ <= '0';
    elsif \AS\ = '1' then \Q\ <= '1';
    elsif rising_edge(\CLK\) then
      \Q\ <= \D\;
    end if;
  end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity \DFFAS\ is
  port (\CLK\ : in std_logic; \D\ : in std_logic; \AS\ : in std_logic; \Q\ : out std_logic);
end entity;
architecture simulation of \DFFAS\ is
begin
  process (\CLK\, \AS\)
  begin
    if \AS\ = '1' then \Q\ <= '1';
    elsif rising_edge(\CLK\) then
      \Q\ <= \D\;
    end if;
  end process;
end architecture;

-- synthesis translate_on
