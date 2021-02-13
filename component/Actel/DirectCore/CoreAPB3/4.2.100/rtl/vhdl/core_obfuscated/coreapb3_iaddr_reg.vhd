-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2011 Microsemi Corporation.  All rights reserved.
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
-- SVN Revision Information:
-- SVN $Revision: 24054 $
-- SVN $Date: 2014-12-08 16:13:40 +0530 (Mon, 08 Dec 2014) $
library iEee;
use IEee.STD_logic_1164.all;
entity CAPB3O is
generic (SYNc_reset: integer := 0;
APb_dwidth: integer range 8 to 32 := 32;
MADDR_bits: integer range 12 to 32 := 32); port (Pclk: in std_logic;
presetn: in std_LOGIC;
penable: in STD_LOGIC;
PSEL: in std_loGIC;
Paddr: in std_LOGIC_VECTor(31 downto 0);
PWRITE: in std_logic;
pwdaTA: in sTD_LOGIC_vector(31 downto 0);
prdata: out STD_LOgic_vector(31 downto 0);
CAPB3L: out STD_logic_vector(31 downto 0));
end entity CAPB3o;

architecture CAPB3i of CAPB3o is

signal CAPB3ol: std_logIC_VECTOR(31 downto 0);

signal CAPB3ll: STD_logic;

signal CAPB3IL: std_loGIC;

constant CAPB3oi: STd_logic_vector(31 downto 0) := ( others => '0');

begin
CAPB3ll <= '1' when (SYNC_reset = 1) else
PRESetn;
CAPB3il <= Presetn when (Sync_reset = 1) else
'1';
process (pclk,CAPB3ll)
begin
if (CAPB3LL = '0') then
CAPB3OL <= ( others => '0');
elsif (pcLK'EVENt and PCLK = '1') then
if (CAPB3IL = '0') then
CAPB3ol <= ( others => '0');
else
if (psel = '1' and penable = '1'
and pwrite = '1') then
if (apb_dwidtH = 32) then
if (paddr(madDR_BITS-4-1 downto 0) = CAPB3oi(MADDR_BITS-4-1 downto 0)) then
CAPB3ol <= PWDATA;
end if;
end if;
if (APB_DWIDTH = 16) then
if (paddr(MADDR_bits-4-1 downto 4) = CAPB3OI(mADDR_BITS-4-1 downto 4)) then
case PADDR(3 downto 0) is
when "0000" =>
CAPB3ol(15 downto 0) <= pwdata(15 downto 0);
when "0100" =>
CAPB3ol(31 downto 16) <= PWData(15 downto 0);
when "1000" =>
CAPB3Ol <= CAPB3OL;
when "1100" =>
CAPB3OL <= CAPB3OL;
when others =>
null
;
end case;
end if;
end if;
if (APB_dwidth = 8) then
if (paddr(maDDR_BITS-4-1 downto 4) = CAPB3oi(MADDR_bits-4-1 downto 4)) then
case pADDR(3 downto 0) is
when "0000" =>
CAPB3OL(7 downto 0) <= PWDATA(7 downto 0);
when "0100" =>
CAPB3ol(15 downto 8) <= Pwdata(7 downto 0);
when "1000" =>
CAPB3OL(23 downto 16) <= Pwdata(7 downto 0);
when "1100" =>
CAPB3ol(31 downto 24) <= Pwdata(7 downto 0);
when others =>
null
;
end case;
end if;
end if;
end if;
end if;
end if;
end process;
CAPB3l <= CAPB3ol;
process (CAPB3OL,Paddr)
begin
pRDATA <= ( others => '0');
if (apb_dwidth = 32) then
if (Paddr(maddr_bits-4-1 downto 0) = CAPB3oi(MADDR_bits-4-1 downto 0)) then
Prdata <= CAPB3OL;
end if;
end if;
if (APB_DWIDTH = 16) then
if (PAddr(maDDR_BITS-4-1 downto 4) = CAPB3oi(MADDR_BITs-4-1 downto 4)) then
case PADDR(3 downto 0) is
when "0000" =>
PRDATA(15 downto 0) <= CAPB3ol(15 downto 0);
when "0100" =>
PRDATA(15 downto 0) <= CAPB3OL(31 downto 16);
when "1000" =>
PRDATA <= ( others => '0');
when "1100" =>
prdata <= ( others => '0');
when others =>
null
;
end case;
end if;
end if;
if (APb_dwidth = 8) then
if (PADdr(MADdr_bits-4-1 downto 4) = CAPB3OI(maddr_bITS-4-1 downto 4)) then
case PADDR(3 downto 0) is
when "0000" =>
Prdata(7 downto 0) <= CAPB3ol(7 downto 0);
when "0100" =>
prdatA(7 downto 0) <= CAPB3ol(15 downto 8);
when "1000" =>
prdata(7 downto 0) <= CAPB3OL(23 downto 16);
when "1100" =>
prdata(7 downto 0) <= CAPB3ol(31 downto 24);
when others =>
null
;
end case;
end if;
end if;
end process;
end architecture CAPB3I;
