--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2012 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity button_pio_s1_arbitrator is 
        port (
              -- inputs:
                 signal button_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal button_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal button_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal button_pio_s1_reset_n : OUT STD_LOGIC;
                 signal cpu_0_data_master_granted_button_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_button_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_button_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_button_pio_s1 : OUT STD_LOGIC;
                 signal d1_button_pio_s1_end_xfer : OUT STD_LOGIC
              );
end entity button_pio_s1_arbitrator;


architecture europa of button_pio_s1_arbitrator is
                signal button_pio_s1_allgrants :  STD_LOGIC;
                signal button_pio_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal button_pio_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal button_pio_s1_any_continuerequest :  STD_LOGIC;
                signal button_pio_s1_arb_counter_enable :  STD_LOGIC;
                signal button_pio_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal button_pio_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal button_pio_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal button_pio_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal button_pio_s1_begins_xfer :  STD_LOGIC;
                signal button_pio_s1_end_xfer :  STD_LOGIC;
                signal button_pio_s1_firsttransfer :  STD_LOGIC;
                signal button_pio_s1_grant_vector :  STD_LOGIC;
                signal button_pio_s1_in_a_read_cycle :  STD_LOGIC;
                signal button_pio_s1_in_a_write_cycle :  STD_LOGIC;
                signal button_pio_s1_master_qreq_vector :  STD_LOGIC;
                signal button_pio_s1_non_bursting_master_requests :  STD_LOGIC;
                signal button_pio_s1_reg_firsttransfer :  STD_LOGIC;
                signal button_pio_s1_slavearbiterlockenable :  STD_LOGIC;
                signal button_pio_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal button_pio_s1_unreg_firsttransfer :  STD_LOGIC;
                signal button_pio_s1_waits_for_read :  STD_LOGIC;
                signal button_pio_s1_waits_for_write :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_button_pio_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_button_pio_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_button_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_button_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_button_pio_s1 :  STD_LOGIC;
                signal shifted_address_to_button_pio_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_button_pio_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT button_pio_s1_end_xfer;
    end if;

  end process;

  button_pio_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_button_pio_s1);
  --assign button_pio_s1_readdata_from_sa = button_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  button_pio_s1_readdata_from_sa <= button_pio_s1_readdata;
  internal_cpu_0_data_master_requests_button_pio_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00000000000000000001100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write)))) AND cpu_0_data_master_read;
  --button_pio_s1_arb_share_counter set values, which is an e_mux
  button_pio_s1_arb_share_set_values <= std_logic_vector'("01");
  --button_pio_s1_non_bursting_master_requests mux, which is an e_mux
  button_pio_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_button_pio_s1;
  --button_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  button_pio_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --button_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  button_pio_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(button_pio_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (button_pio_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(button_pio_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (button_pio_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --button_pio_s1_allgrants all slave grants, which is an e_mux
  button_pio_s1_allgrants <= button_pio_s1_grant_vector;
  --button_pio_s1_end_xfer assignment, which is an e_assign
  button_pio_s1_end_xfer <= NOT ((button_pio_s1_waits_for_read OR button_pio_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_button_pio_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_button_pio_s1 <= button_pio_s1_end_xfer AND (((NOT button_pio_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --button_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  button_pio_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_button_pio_s1 AND button_pio_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_button_pio_s1 AND NOT button_pio_s1_non_bursting_master_requests));
  --button_pio_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      button_pio_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(button_pio_s1_arb_counter_enable) = '1' then 
        button_pio_s1_arb_share_counter <= button_pio_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --button_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      button_pio_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((button_pio_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_button_pio_s1)) OR ((end_xfer_arb_share_counter_term_button_pio_s1 AND NOT button_pio_s1_non_bursting_master_requests)))) = '1' then 
        button_pio_s1_slavearbiterlockenable <= or_reduce(button_pio_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master button_pio/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= button_pio_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --button_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  button_pio_s1_slavearbiterlockenable2 <= or_reduce(button_pio_s1_arb_share_counter_next_value);
  --cpu_0/data_master button_pio/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= button_pio_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --button_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  button_pio_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_button_pio_s1 <= internal_cpu_0_data_master_requests_button_pio_s1 AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_button_pio_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_button_pio_s1 <= (internal_cpu_0_data_master_granted_button_pio_s1 AND cpu_0_data_master_read) AND NOT button_pio_s1_waits_for_read;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_button_pio_s1 <= internal_cpu_0_data_master_qualified_request_button_pio_s1;
  --cpu_0/data_master saved-grant button_pio/s1, which is an e_assign
  cpu_0_data_master_saved_grant_button_pio_s1 <= internal_cpu_0_data_master_requests_button_pio_s1;
  --allow new arb cycle for button_pio/s1, which is an e_assign
  button_pio_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  button_pio_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  button_pio_s1_master_qreq_vector <= std_logic'('1');
  --button_pio_s1_reset_n assignment, which is an e_assign
  button_pio_s1_reset_n <= reset_n;
  --button_pio_s1_firsttransfer first transaction, which is an e_assign
  button_pio_s1_firsttransfer <= A_WE_StdLogic((std_logic'(button_pio_s1_begins_xfer) = '1'), button_pio_s1_unreg_firsttransfer, button_pio_s1_reg_firsttransfer);
  --button_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  button_pio_s1_unreg_firsttransfer <= NOT ((button_pio_s1_slavearbiterlockenable AND button_pio_s1_any_continuerequest));
  --button_pio_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      button_pio_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(button_pio_s1_begins_xfer) = '1' then 
        button_pio_s1_reg_firsttransfer <= button_pio_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --button_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  button_pio_s1_beginbursttransfer_internal <= button_pio_s1_begins_xfer;
  shifted_address_to_button_pio_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --button_pio_s1_address mux, which is an e_mux
  button_pio_s1_address <= A_EXT (A_SRL(shifted_address_to_button_pio_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_button_pio_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_button_pio_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_button_pio_s1_end_xfer <= button_pio_s1_end_xfer;
    end if;

  end process;

  --button_pio_s1_waits_for_read in a cycle, which is an e_mux
  button_pio_s1_waits_for_read <= button_pio_s1_in_a_read_cycle AND button_pio_s1_begins_xfer;
  --button_pio_s1_in_a_read_cycle assignment, which is an e_assign
  button_pio_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_button_pio_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= button_pio_s1_in_a_read_cycle;
  --button_pio_s1_waits_for_write in a cycle, which is an e_mux
  button_pio_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(button_pio_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --button_pio_s1_in_a_write_cycle assignment, which is an e_assign
  button_pio_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_button_pio_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= button_pio_s1_in_a_write_cycle;
  wait_for_button_pio_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_button_pio_s1 <= internal_cpu_0_data_master_granted_button_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_button_pio_s1 <= internal_cpu_0_data_master_qualified_request_button_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_button_pio_s1 <= internal_cpu_0_data_master_requests_button_pio_s1;
--synthesis translate_off
    --button_pio/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_0_jtag_debug_module_arbitrator;


architecture europa of cpu_0_jtag_debug_module_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_cpu_0_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  cpu_0_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  --assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_readdata_from_sa <= cpu_0_jtag_debug_module_readdata;
  internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000100000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_0_jtag_debug_module_arb_share_set_values <= std_logic_vector'("01");
  --cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_0_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_0_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_0_jtag_debug_module_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_0_jtag_debug_module_allgrants <= (((or_reduce(cpu_0_jtag_debug_module_grant_vector)) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector));
  --cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_0_jtag_debug_module_end_xfer <= NOT ((cpu_0_jtag_debug_module_waits_for_read OR cpu_0_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_end_xfer AND (((NOT cpu_0_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_0_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND cpu_0_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests));
  --cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_0_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_0_jtag_debug_module_slavearbiterlockenable <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_0_jtag_debug_module_slavearbiterlockenable2 <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_0_jtag_debug_module_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module AND NOT ((((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))))) OR cpu_0_instruction_master_arbiterlock));
  --local readdatavalid cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module <= (internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_read) AND NOT cpu_0_jtag_debug_module_waits_for_read;
  --cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  cpu_0_jtag_debug_module_writedata <= cpu_0_data_master_writedata;
  internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000100000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module AND NOT ((((cpu_0_instruction_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))))) OR cpu_0_data_master_arbiterlock));
  --local readdatavalid cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module <= (internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module AND cpu_0_instruction_master_read) AND NOT cpu_0_jtag_debug_module_waits_for_read;
  --allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(0);
  --cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(0) AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(1);
  --cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(1) AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_0_jtag_debug_module_master_qreq_vector & cpu_0_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_0_jtag_debug_module_master_qreq_vector & NOT cpu_0_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_0_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_0_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_0_jtag_debug_module_grant_vector)))) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_0_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_0_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(1) OR cpu_0_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(0) OR cpu_0_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu_0/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1' then 
        cpu_0_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_end_xfer) = '1'), cpu_0_jtag_debug_module_chosen_master_rot_left, cpu_0_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_0_jtag_debug_module_begintransfer <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  cpu_0_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_resetrequest_from_sa <= cpu_0_jtag_debug_module_resetrequest;
  cpu_0_jtag_debug_module_chipselect <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1'), cpu_0_jtag_debug_module_unreg_firsttransfer, cpu_0_jtag_debug_module_reg_firsttransfer);
  --cpu_0_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_jtag_debug_module_any_continuerequest));
  --cpu_0_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1' then 
        cpu_0_jtag_debug_module_reg_firsttransfer <= cpu_0_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_0_jtag_debug_module_beginbursttransfer_internal <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_0_jtag_debug_module_arbitration_holdoff_internal <= cpu_0_jtag_debug_module_begins_xfer AND cpu_0_jtag_debug_module_firsttransfer;
  --cpu_0_jtag_debug_module_write assignment, which is an e_mux
  cpu_0_jtag_debug_module_write <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --cpu_0_jtag_debug_module_address mux, which is an e_mux
  cpu_0_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master <= cpu_0_instruction_master_address_to_slave;
  --d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_0_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  --cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_read <= cpu_0_jtag_debug_module_in_a_read_cycle AND cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_0_jtag_debug_module_in_a_read_cycle;
  --cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_write_cycle <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_0_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_0_jtag_debug_module_counter <= std_logic'('0');
  --cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_0_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_0_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
--synthesis translate_off
    --cpu_0/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_data_master_arbitrator is 
        port (
              -- inputs:
                 signal button_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_byteenable_sdram_0_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_button_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_lcd_display_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_led_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_seven_seg_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_button_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_lcd_display_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_led_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_seven_seg_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_button_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_lcd_display_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_led_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_seven_seg_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_button_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_lcd_display_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_led_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_seven_seg_pio_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sysid_control_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_button_pio_s1_end_xfer : IN STD_LOGIC;
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_lcd_display_control_slave_end_xfer : IN STD_LOGIC;
                 signal d1_led_pio_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_seven_seg_pio_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sys_clk_timer_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sysid_control_slave_end_xfer : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal lcd_display_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal lcd_display_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                 signal led_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;
                 signal seven_seg_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sys_clk_timer_s1_irq_from_sa : IN STD_LOGIC;
                 signal sys_clk_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sysid_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : OUT STD_LOGIC;
                 signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_readdatavalid : OUT STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_data_master_arbitrator;


architecture europa of cpu_0_data_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_0_data_master_address_last_time :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_data_master_byteenable_last_time :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_data_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_rdv_counter_inc :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_is_granted_some_slave :  STD_LOGIC;
                signal cpu_0_data_master_next_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_read_but_no_slave_selected :  STD_LOGIC;
                signal cpu_0_data_master_read_last_time :  STD_LOGIC;
                signal cpu_0_data_master_run :  STD_LOGIC;
                signal cpu_0_data_master_write_last_time :  STD_LOGIC;
                signal cpu_0_data_master_writedata_last_time :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_rdv_count_enable :  STD_LOGIC;
                signal dbs_rdv_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal internal_cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_latency_counter :  STD_LOGIC;
                signal internal_cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal latency_load_value :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_cpu_0_data_master_latency_counter :  STD_LOGIC;
                signal p1_dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal pre_flush_cpu_0_data_master_readdatavalid :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_button_pio_s1 OR NOT cpu_0_data_master_requests_button_pio_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_button_pio_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_button_pio_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_button_pio_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_0_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_lcd_display_control_slave OR NOT cpu_0_data_master_requests_lcd_display_control_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_lcd_display_control_slave OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((lcd_display_control_slave_wait_counter_eq_0 AND NOT d1_lcd_display_control_slave_end_xfer)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_lcd_display_control_slave OR NOT cpu_0_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((lcd_display_control_slave_wait_counter_eq_0 AND NOT d1_lcd_display_control_slave_end_xfer)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_led_pio_s1 OR NOT cpu_0_data_master_requests_led_pio_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_led_pio_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_led_pio_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_0_data_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic(((((((((((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_led_pio_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_0_data_master_qualified_request_sdram_0_s1 OR (((cpu_0_data_master_write AND NOT(or_reduce(cpu_0_data_master_byteenable_sdram_0_s1))) AND internal_cpu_0_data_master_dbs_address(1)))) OR NOT cpu_0_data_master_requests_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_sdram_0_s1 OR NOT cpu_0_data_master_qualified_request_sdram_0_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sdram_0_s1 OR NOT cpu_0_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sdram_0_s1 OR NOT cpu_0_data_master_write)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_seven_seg_pio_s1 OR NOT cpu_0_data_master_requests_seven_seg_pio_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_seven_seg_pio_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_seven_seg_pio_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_seven_seg_pio_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_0_data_master_requests_sys_clk_timer_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sys_clk_timer_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_sysid_control_slave OR NOT cpu_0_data_master_requests_sysid_control_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sysid_control_slave OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sysid_control_slave_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sysid_control_slave OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_data_master_address_to_slave <= Std_Logic_Vector'(A_ToStdLogicVector(cpu_0_data_master_address(25)) & std_logic_vector'("00") & cpu_0_data_master_address(22 DOWNTO 0));
  --cpu_0_data_master_read_but_no_slave_selected assignment, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_data_master_read_but_no_slave_selected <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_0_data_master_read_but_no_slave_selected <= (cpu_0_data_master_read AND cpu_0_data_master_run) AND NOT cpu_0_data_master_is_granted_some_slave;
    end if;

  end process;

  --some slave is getting selected, which is an e_mux
  cpu_0_data_master_is_granted_some_slave <= (((((((cpu_0_data_master_granted_button_pio_s1 OR cpu_0_data_master_granted_cpu_0_jtag_debug_module) OR cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave) OR cpu_0_data_master_granted_lcd_display_control_slave) OR cpu_0_data_master_granted_led_pio_s1) OR cpu_0_data_master_granted_sdram_0_s1) OR cpu_0_data_master_granted_seven_seg_pio_s1) OR cpu_0_data_master_granted_sys_clk_timer_s1) OR cpu_0_data_master_granted_sysid_control_slave;
  --latent slave read data valids which may be flushed, which is an e_mux
  pre_flush_cpu_0_data_master_readdatavalid <= cpu_0_data_master_read_data_valid_sdram_0_s1 AND dbs_rdv_counter_overflow;
  --latent slave read data valid which is not flushed, which is an e_mux
  cpu_0_data_master_readdatavalid <= ((((((((((((((((((((((((cpu_0_data_master_read_but_no_slave_selected OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_button_pio_s1) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_lcd_display_control_slave) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_led_pio_s1) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_seven_seg_pio_s1) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_sys_clk_timer_s1) OR cpu_0_data_master_read_but_no_slave_selected) OR pre_flush_cpu_0_data_master_readdatavalid) OR cpu_0_data_master_read_data_valid_sysid_control_slave;
  --cpu_0/data_master readdata mux, which is an e_mux
  cpu_0_data_master_readdata <= (((((((((A_REP(NOT ((cpu_0_data_master_qualified_request_button_pio_s1 AND cpu_0_data_master_read)) , 32) OR button_pio_s1_readdata_from_sa)) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module AND cpu_0_data_master_read)) , 32) OR cpu_0_jtag_debug_module_readdata_from_sa))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read)) , 32) OR jtag_uart_0_avalon_jtag_slave_readdata_from_sa))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_lcd_display_control_slave AND cpu_0_data_master_read)) , 32) OR (std_logic_vector'("000000000000000000000000") & (lcd_display_control_slave_readdata_from_sa))))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_led_pio_s1 AND cpu_0_data_master_read)) , 32) OR led_pio_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_read_data_valid_sdram_0_s1, 32) OR Std_Logic_Vector'(sdram_0_s1_readdata_from_sa(15 DOWNTO 0) & dbs_latent_16_reg_segment_0)))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_seven_seg_pio_s1 AND cpu_0_data_master_read)) , 32) OR seven_seg_pio_s1_readdata_from_sa))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_sys_clk_timer_s1 AND cpu_0_data_master_read)) , 32) OR (std_logic_vector'("0000000000000000") & (sys_clk_timer_s1_readdata_from_sa))))) AND ((A_REP(NOT ((cpu_0_data_master_qualified_request_sysid_control_slave AND cpu_0_data_master_read)) , 32) OR sysid_control_slave_readdata_from_sa));
  --actual waitrequest port, which is an e_assign
  internal_cpu_0_data_master_waitrequest <= NOT cpu_0_data_master_run;
  --latent max counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_latency_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_0_data_master_latency_counter <= p1_cpu_0_data_master_latency_counter;
    end if;

  end process;

  --latency counter load mux, which is an e_mux
  p1_cpu_0_data_master_latency_counter <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((cpu_0_data_master_run AND cpu_0_data_master_read))) = '1'), (std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(latency_load_value))), A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_latency_counter)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_latency_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  --read latency load values, which is an e_mux
  latency_load_value <= std_logic'('0');
  --irq assign, which is an e_assign
  cpu_0_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(jtag_uart_0_avalon_jtag_slave_irq_from_sa) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(sys_clk_timer_s1_irq_from_sa));
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic((((((((NOT std_logic_vector'("00000000000000000000000000000000")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_requests_sdram_0_s1)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT(or_reduce(cpu_0_data_master_byteenable_sdram_0_s1))))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))))));
  --input to latent dbs-16 stored 0, which is an e_mux
  p1_dbs_latent_16_reg_segment_0 <= sdram_0_s1_readdata_from_sa;
  --dbs register for latent dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_latent_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_rdv_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_dbs_rdv_counter(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
      end if;
    end if;

  end process;

  --mux write dbs 1, which is an e_mux
  cpu_0_data_master_dbs_write_16 <= A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_dbs_address(1))) = '1'), cpu_0_data_master_writedata(31 DOWNTO 16), cpu_0_data_master_writedata(15 DOWNTO 0));
  --dbs count increment, which is an e_mux
  cpu_0_data_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_data_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_data_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_data_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_data_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --p1 dbs rdv counter, which is an e_assign
  cpu_0_data_master_next_dbs_rdv_counter <= A_EXT (((std_logic_vector'("0") & (cpu_0_data_master_dbs_rdv_counter)) + (std_logic_vector'("0") & (cpu_0_data_master_dbs_rdv_counter_inc))), 2);
  --cpu_0_data_master_rdv_inc_mux, which is an e_mux
  cpu_0_data_master_dbs_rdv_counter_inc <= std_logic_vector'("10");
  --master any slave rdv, which is an e_mux
  dbs_rdv_count_enable <= cpu_0_data_master_read_data_valid_sdram_0_s1;
  --dbs rdv counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_data_master_dbs_rdv_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_rdv_count_enable) = '1' then 
        cpu_0_data_master_dbs_rdv_counter <= cpu_0_data_master_next_dbs_rdv_counter;
      end if;
    end if;

  end process;

  --dbs rdv counter overflow, which is an e_assign
  dbs_rdv_counter_overflow <= cpu_0_data_master_dbs_rdv_counter(1) AND NOT cpu_0_data_master_next_dbs_rdv_counter(1);
  --vhdl renameroo for output signals
  cpu_0_data_master_address_to_slave <= internal_cpu_0_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_dbs_address <= internal_cpu_0_data_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_data_master_latency_counter <= internal_cpu_0_data_master_latency_counter;
  --vhdl renameroo for output signals
  cpu_0_data_master_waitrequest <= internal_cpu_0_data_master_waitrequest;
--synthesis translate_off
    --cpu_0_data_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_data_master_address_last_time <= std_logic_vector'("00000000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_0_data_master_address_last_time <= cpu_0_data_master_address;
      end if;

    end process;

    --cpu_0/data_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_0_data_master_waitrequest AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
      end if;

    end process;

    --cpu_0_data_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_0_data_master_address /= cpu_0_data_master_address_last_time))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("cpu_0_data_master_address did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_data_master_byteenable check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_data_master_byteenable_last_time <= std_logic_vector'("0000");
      elsif clk'event and clk = '1' then
        cpu_0_data_master_byteenable_last_time <= cpu_0_data_master_byteenable;
      end if;

    end process;

    --cpu_0_data_master_byteenable matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_0_data_master_byteenable /= cpu_0_data_master_byteenable_last_time))))) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("cpu_0_data_master_byteenable did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_data_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_data_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_0_data_master_read_last_time <= cpu_0_data_master_read;
      end if;

    end process;

    --cpu_0_data_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_0_data_master_read) /= std_logic'(cpu_0_data_master_read_last_time)))))) = '1' then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("cpu_0_data_master_read did not heed wait!!!"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_data_master_write check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_data_master_write_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_0_data_master_write_last_time <= cpu_0_data_master_write;
      end if;

    end process;

    --cpu_0_data_master_write matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_0_data_master_write) /= std_logic'(cpu_0_data_master_write_last_time)))))) = '1' then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("cpu_0_data_master_write did not heed wait!!!"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_data_master_writedata check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_data_master_writedata_last_time <= std_logic_vector'("00000000000000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_0_data_master_writedata_last_time <= cpu_0_data_master_writedata;
      end if;

    end process;

    --cpu_0_data_master_writedata matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line6 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((active_and_waiting_last_time AND to_std_logic(((cpu_0_data_master_writedata /= cpu_0_data_master_writedata_last_time)))) AND cpu_0_data_master_write)) = '1' then 
          write(write_line6, now);
          write(write_line6, string'(": "));
          write(write_line6, string'("cpu_0_data_master_writedata did not heed wait!!!"));
          write(output, write_line6.all);
          deallocate (write_line6);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sdram_0_s1 : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_latency_counter : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_readdatavalid : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_instruction_master_arbitrator;


architecture europa of cpu_0_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_address_last_time :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_rdv_counter_inc :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_is_granted_some_slave :  STD_LOGIC;
                signal cpu_0_instruction_master_next_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_read_but_no_slave_selected :  STD_LOGIC;
                signal cpu_0_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_run :  STD_LOGIC;
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_rdv_count_enable :  STD_LOGIC;
                signal dbs_rdv_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal internal_cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_instruction_master_latency_counter :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal latency_load_value :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_cpu_0_instruction_master_latency_counter :  STD_LOGIC;
                signal p1_dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal pre_flush_cpu_0_instruction_master_readdatavalid :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_0_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_0_instruction_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_qualified_request_sdram_0_s1 OR NOT cpu_0_instruction_master_requests_sdram_0_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_sdram_0_s1 OR NOT cpu_0_instruction_master_qualified_request_sdram_0_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_instruction_master_qualified_request_sdram_0_s1 OR NOT cpu_0_instruction_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_instruction_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_instruction_master_address_to_slave <= Std_Logic_Vector'(A_ToStdLogicVector(cpu_0_instruction_master_address(25)) & std_logic_vector'("00") & cpu_0_instruction_master_address(22 DOWNTO 0));
  --cpu_0_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_instruction_master_read_but_no_slave_selected <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_0_instruction_master_read_but_no_slave_selected <= (cpu_0_instruction_master_read AND cpu_0_instruction_master_run) AND NOT cpu_0_instruction_master_is_granted_some_slave;
    end if;

  end process;

  --some slave is getting selected, which is an e_mux
  cpu_0_instruction_master_is_granted_some_slave <= cpu_0_instruction_master_granted_cpu_0_jtag_debug_module OR cpu_0_instruction_master_granted_sdram_0_s1;
  --latent slave read data valids which may be flushed, which is an e_mux
  pre_flush_cpu_0_instruction_master_readdatavalid <= cpu_0_instruction_master_read_data_valid_sdram_0_s1 AND dbs_rdv_counter_overflow;
  --latent slave read data valid which is not flushed, which is an e_mux
  cpu_0_instruction_master_readdatavalid <= (((cpu_0_instruction_master_read_but_no_slave_selected OR pre_flush_cpu_0_instruction_master_readdatavalid) OR cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module) OR cpu_0_instruction_master_read_but_no_slave_selected) OR pre_flush_cpu_0_instruction_master_readdatavalid;
  --cpu_0/instruction_master readdata mux, which is an e_mux
  cpu_0_instruction_master_readdata <= ((A_REP(NOT ((cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module AND cpu_0_instruction_master_read)) , 32) OR cpu_0_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_0_instruction_master_read_data_valid_sdram_0_s1, 32) OR Std_Logic_Vector'(sdram_0_s1_readdata_from_sa(15 DOWNTO 0) & dbs_latent_16_reg_segment_0)));
  --actual waitrequest port, which is an e_assign
  internal_cpu_0_instruction_master_waitrequest <= NOT cpu_0_instruction_master_run;
  --latent max counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_instruction_master_latency_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_0_instruction_master_latency_counter <= p1_cpu_0_instruction_master_latency_counter;
    end if;

  end process;

  --latency counter load mux, which is an e_mux
  p1_cpu_0_instruction_master_latency_counter <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((cpu_0_instruction_master_run AND cpu_0_instruction_master_read))) = '1'), (std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(latency_load_value))), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_latency_counter)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_latency_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  --read latency load values, which is an e_mux
  latency_load_value <= std_logic'('0');
  --input to latent dbs-16 stored 0, which is an e_mux
  p1_dbs_latent_16_reg_segment_0 <= sdram_0_s1_readdata_from_sa;
  --dbs register for latent dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_latent_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_rdv_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_instruction_master_dbs_rdv_counter(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_0_instruction_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_instruction_master_requests_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_instruction_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_instruction_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_instruction_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_instruction_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_instruction_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --p1 dbs rdv counter, which is an e_assign
  cpu_0_instruction_master_next_dbs_rdv_counter <= A_EXT (((std_logic_vector'("0") & (cpu_0_instruction_master_dbs_rdv_counter)) + (std_logic_vector'("0") & (cpu_0_instruction_master_dbs_rdv_counter_inc))), 2);
  --cpu_0_instruction_master_rdv_inc_mux, which is an e_mux
  cpu_0_instruction_master_dbs_rdv_counter_inc <= std_logic_vector'("10");
  --master any slave rdv, which is an e_mux
  dbs_rdv_count_enable <= cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  --dbs rdv counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_instruction_master_dbs_rdv_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_rdv_count_enable) = '1' then 
        cpu_0_instruction_master_dbs_rdv_counter <= cpu_0_instruction_master_next_dbs_rdv_counter;
      end if;
    end if;

  end process;

  --dbs rdv counter overflow, which is an e_assign
  dbs_rdv_counter_overflow <= cpu_0_instruction_master_dbs_rdv_counter(1) AND NOT cpu_0_instruction_master_next_dbs_rdv_counter(1);
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_instruction_master_granted_sdram_0_s1 AND cpu_0_instruction_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_0_s1_waitrequest_from_sa)))));
  --vhdl renameroo for output signals
  cpu_0_instruction_master_address_to_slave <= internal_cpu_0_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_dbs_address <= internal_cpu_0_instruction_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_latency_counter <= internal_cpu_0_instruction_master_latency_counter;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_waitrequest <= internal_cpu_0_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_0_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_address_last_time <= std_logic_vector'("00000000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
      end if;

    end process;

    --cpu_0/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_0_instruction_master_waitrequest AND (cpu_0_instruction_master_read);
      end if;

    end process;

    --cpu_0_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line7 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_0_instruction_master_address /= cpu_0_instruction_master_address_last_time))))) = '1' then 
          write(write_line7, now);
          write(write_line7, string'(": "));
          write(write_line7, string'("cpu_0_instruction_master_address did not heed wait!!!"));
          write(output, write_line7.all);
          deallocate (write_line7);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
      end if;

    end process;

    --cpu_0_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line8 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_0_instruction_master_read) /= std_logic'(cpu_0_instruction_master_read_last_time)))))) = '1' then 
          write(write_line8, now);
          write(write_line8, string'(": "));
          write(write_line8, string'("cpu_0_instruction_master_read did not heed wait!!!"));
          write(output, write_line8.all);
          deallocate (write_line8);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_0_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_0_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_0_avalon_jtag_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_jtag_uart_0_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_0_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave);
  --assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readdata_from_sa <= jtag_uart_0_avalon_jtag_slave_readdata;
  internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("00000000000000000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_0_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_0_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_0_avalon_jtag_slave_waitrequest;
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_arb_share_set_values <= std_logic_vector'("01");
  --jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(jtag_uart_0_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_allgrants <= jtag_uart_0_avalon_jtag_slave_grant_vector;
  --jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_0_avalon_jtag_slave_waits_for_read OR jtag_uart_0_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave <= jtag_uart_0_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND jtag_uart_0_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_0_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave, which is an e_mux
  cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave <= (internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read) AND NOT jtag_uart_0_avalon_jtag_slave_waits_for_read;
  --jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_0_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_0_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_0_avalon_jtag_slave_chipselect <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_0_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_0_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_0_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_read_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read));
  --~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_write_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write));
  shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_read <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_write <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_0_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_irq_from_sa <= jtag_uart_0_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity lcd_display_control_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal lcd_display_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_lcd_display_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_lcd_display_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_lcd_display_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_lcd_display_control_slave : OUT STD_LOGIC;
                 signal d1_lcd_display_control_slave_end_xfer : OUT STD_LOGIC;
                 signal lcd_display_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal lcd_display_control_slave_begintransfer : OUT STD_LOGIC;
                 signal lcd_display_control_slave_read : OUT STD_LOGIC;
                 signal lcd_display_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal lcd_display_control_slave_reset_n : OUT STD_LOGIC;
                 signal lcd_display_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                 signal lcd_display_control_slave_write : OUT STD_LOGIC;
                 signal lcd_display_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity lcd_display_control_slave_arbitrator;


architecture europa of lcd_display_control_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_lcd_display_control_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_lcd_display_control_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_lcd_display_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_lcd_display_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_lcd_display_control_slave :  STD_LOGIC;
                signal internal_lcd_display_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal lcd_display_control_slave_allgrants :  STD_LOGIC;
                signal lcd_display_control_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal lcd_display_control_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal lcd_display_control_slave_any_continuerequest :  STD_LOGIC;
                signal lcd_display_control_slave_arb_counter_enable :  STD_LOGIC;
                signal lcd_display_control_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal lcd_display_control_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal lcd_display_control_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal lcd_display_control_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal lcd_display_control_slave_begins_xfer :  STD_LOGIC;
                signal lcd_display_control_slave_counter_load_value :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal lcd_display_control_slave_end_xfer :  STD_LOGIC;
                signal lcd_display_control_slave_firsttransfer :  STD_LOGIC;
                signal lcd_display_control_slave_grant_vector :  STD_LOGIC;
                signal lcd_display_control_slave_in_a_read_cycle :  STD_LOGIC;
                signal lcd_display_control_slave_in_a_write_cycle :  STD_LOGIC;
                signal lcd_display_control_slave_master_qreq_vector :  STD_LOGIC;
                signal lcd_display_control_slave_non_bursting_master_requests :  STD_LOGIC;
                signal lcd_display_control_slave_pretend_byte_enable :  STD_LOGIC;
                signal lcd_display_control_slave_reg_firsttransfer :  STD_LOGIC;
                signal lcd_display_control_slave_slavearbiterlockenable :  STD_LOGIC;
                signal lcd_display_control_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal lcd_display_control_slave_unreg_firsttransfer :  STD_LOGIC;
                signal lcd_display_control_slave_wait_counter :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal lcd_display_control_slave_waits_for_read :  STD_LOGIC;
                signal lcd_display_control_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_lcd_display_control_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_lcd_display_control_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT lcd_display_control_slave_end_xfer;
    end if;

  end process;

  lcd_display_control_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_lcd_display_control_slave);
  --assign lcd_display_control_slave_readdata_from_sa = lcd_display_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  lcd_display_control_slave_readdata_from_sa <= lcd_display_control_slave_readdata;
  internal_cpu_0_data_master_requests_lcd_display_control_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00000000000000000000110000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --lcd_display_control_slave_arb_share_counter set values, which is an e_mux
  lcd_display_control_slave_arb_share_set_values <= std_logic_vector'("01");
  --lcd_display_control_slave_non_bursting_master_requests mux, which is an e_mux
  lcd_display_control_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_lcd_display_control_slave;
  --lcd_display_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  lcd_display_control_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --lcd_display_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  lcd_display_control_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(lcd_display_control_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (lcd_display_control_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(lcd_display_control_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (lcd_display_control_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --lcd_display_control_slave_allgrants all slave grants, which is an e_mux
  lcd_display_control_slave_allgrants <= lcd_display_control_slave_grant_vector;
  --lcd_display_control_slave_end_xfer assignment, which is an e_assign
  lcd_display_control_slave_end_xfer <= NOT ((lcd_display_control_slave_waits_for_read OR lcd_display_control_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_lcd_display_control_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_lcd_display_control_slave <= lcd_display_control_slave_end_xfer AND (((NOT lcd_display_control_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --lcd_display_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  lcd_display_control_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_lcd_display_control_slave AND lcd_display_control_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_lcd_display_control_slave AND NOT lcd_display_control_slave_non_bursting_master_requests));
  --lcd_display_control_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_display_control_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(lcd_display_control_slave_arb_counter_enable) = '1' then 
        lcd_display_control_slave_arb_share_counter <= lcd_display_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --lcd_display_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_display_control_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((lcd_display_control_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_lcd_display_control_slave)) OR ((end_xfer_arb_share_counter_term_lcd_display_control_slave AND NOT lcd_display_control_slave_non_bursting_master_requests)))) = '1' then 
        lcd_display_control_slave_slavearbiterlockenable <= or_reduce(lcd_display_control_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master lcd_display/control_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= lcd_display_control_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --lcd_display_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  lcd_display_control_slave_slavearbiterlockenable2 <= or_reduce(lcd_display_control_slave_arb_share_counter_next_value);
  --cpu_0/data_master lcd_display/control_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= lcd_display_control_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --lcd_display_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  lcd_display_control_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_lcd_display_control_slave <= internal_cpu_0_data_master_requests_lcd_display_control_slave AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_lcd_display_control_slave, which is an e_mux
  cpu_0_data_master_read_data_valid_lcd_display_control_slave <= (internal_cpu_0_data_master_granted_lcd_display_control_slave AND cpu_0_data_master_read) AND NOT lcd_display_control_slave_waits_for_read;
  --lcd_display_control_slave_writedata mux, which is an e_mux
  lcd_display_control_slave_writedata <= cpu_0_data_master_writedata (7 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_lcd_display_control_slave <= internal_cpu_0_data_master_qualified_request_lcd_display_control_slave;
  --cpu_0/data_master saved-grant lcd_display/control_slave, which is an e_assign
  cpu_0_data_master_saved_grant_lcd_display_control_slave <= internal_cpu_0_data_master_requests_lcd_display_control_slave;
  --allow new arb cycle for lcd_display/control_slave, which is an e_assign
  lcd_display_control_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  lcd_display_control_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  lcd_display_control_slave_master_qreq_vector <= std_logic'('1');
  lcd_display_control_slave_begintransfer <= lcd_display_control_slave_begins_xfer;
  --lcd_display_control_slave_reset_n assignment, which is an e_assign
  lcd_display_control_slave_reset_n <= reset_n;
  --lcd_display_control_slave_firsttransfer first transaction, which is an e_assign
  lcd_display_control_slave_firsttransfer <= A_WE_StdLogic((std_logic'(lcd_display_control_slave_begins_xfer) = '1'), lcd_display_control_slave_unreg_firsttransfer, lcd_display_control_slave_reg_firsttransfer);
  --lcd_display_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  lcd_display_control_slave_unreg_firsttransfer <= NOT ((lcd_display_control_slave_slavearbiterlockenable AND lcd_display_control_slave_any_continuerequest));
  --lcd_display_control_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_display_control_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(lcd_display_control_slave_begins_xfer) = '1' then 
        lcd_display_control_slave_reg_firsttransfer <= lcd_display_control_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --lcd_display_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  lcd_display_control_slave_beginbursttransfer_internal <= lcd_display_control_slave_begins_xfer;
  --lcd_display_control_slave_read assignment, which is an e_mux
  lcd_display_control_slave_read <= (((internal_cpu_0_data_master_granted_lcd_display_control_slave AND cpu_0_data_master_read)) AND NOT lcd_display_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_display_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000001101"))));
  --lcd_display_control_slave_write assignment, which is an e_mux
  lcd_display_control_slave_write <= (((((internal_cpu_0_data_master_granted_lcd_display_control_slave AND cpu_0_data_master_write)) AND NOT lcd_display_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_display_control_slave_wait_counter))>=std_logic_vector'("00000000000000000000000000001101"))))) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_display_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000011010"))))) AND lcd_display_control_slave_pretend_byte_enable;
  shifted_address_to_lcd_display_control_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --lcd_display_control_slave_address mux, which is an e_mux
  lcd_display_control_slave_address <= A_EXT (A_SRL(shifted_address_to_lcd_display_control_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_lcd_display_control_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_lcd_display_control_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_lcd_display_control_slave_end_xfer <= lcd_display_control_slave_end_xfer;
    end if;

  end process;

  --lcd_display_control_slave_waits_for_read in a cycle, which is an e_mux
  lcd_display_control_slave_waits_for_read <= lcd_display_control_slave_in_a_read_cycle AND wait_for_lcd_display_control_slave_counter;
  --lcd_display_control_slave_in_a_read_cycle assignment, which is an e_assign
  lcd_display_control_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_lcd_display_control_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= lcd_display_control_slave_in_a_read_cycle;
  --lcd_display_control_slave_waits_for_write in a cycle, which is an e_mux
  lcd_display_control_slave_waits_for_write <= lcd_display_control_slave_in_a_write_cycle AND wait_for_lcd_display_control_slave_counter;
  --lcd_display_control_slave_in_a_write_cycle assignment, which is an e_assign
  lcd_display_control_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_lcd_display_control_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= lcd_display_control_slave_in_a_write_cycle;
  internal_lcd_display_control_slave_wait_counter_eq_0 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (lcd_display_control_slave_wait_counter)) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_display_control_slave_wait_counter <= std_logic_vector'("000000");
    elsif clk'event and clk = '1' then
      lcd_display_control_slave_wait_counter <= lcd_display_control_slave_counter_load_value;
    end if;

  end process;

  lcd_display_control_slave_counter_load_value <= A_EXT (A_WE_StdLogicVector((std_logic'(((lcd_display_control_slave_in_a_write_cycle AND lcd_display_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000100101"), A_WE_StdLogicVector((std_logic'(((lcd_display_control_slave_in_a_read_cycle AND lcd_display_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000011000"), A_WE_StdLogicVector((std_logic'((NOT internal_lcd_display_control_slave_wait_counter_eq_0)) = '1'), ((std_logic_vector'("000000000000000000000000000") & (lcd_display_control_slave_wait_counter)) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000")))), 6);
  wait_for_lcd_display_control_slave_counter <= lcd_display_control_slave_begins_xfer OR NOT internal_lcd_display_control_slave_wait_counter_eq_0;
  --lcd_display_control_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  lcd_display_control_slave_pretend_byte_enable <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_lcd_display_control_slave)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))));
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_lcd_display_control_slave <= internal_cpu_0_data_master_granted_lcd_display_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_lcd_display_control_slave <= internal_cpu_0_data_master_qualified_request_lcd_display_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_lcd_display_control_slave <= internal_cpu_0_data_master_requests_lcd_display_control_slave;
  --vhdl renameroo for output signals
  lcd_display_control_slave_wait_counter_eq_0 <= internal_lcd_display_control_slave_wait_counter_eq_0;
--synthesis translate_off
    --lcd_display/control_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity led_pio_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal led_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_led_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_led_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_led_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_led_pio_s1 : OUT STD_LOGIC;
                 signal d1_led_pio_s1_end_xfer : OUT STD_LOGIC;
                 signal led_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal led_pio_s1_chipselect : OUT STD_LOGIC;
                 signal led_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal led_pio_s1_reset_n : OUT STD_LOGIC;
                 signal led_pio_s1_write_n : OUT STD_LOGIC;
                 signal led_pio_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity led_pio_s1_arbitrator;


architecture europa of led_pio_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_led_pio_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_led_pio_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_led_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_led_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_led_pio_s1 :  STD_LOGIC;
                signal led_pio_s1_allgrants :  STD_LOGIC;
                signal led_pio_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal led_pio_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal led_pio_s1_any_continuerequest :  STD_LOGIC;
                signal led_pio_s1_arb_counter_enable :  STD_LOGIC;
                signal led_pio_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal led_pio_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal led_pio_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal led_pio_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal led_pio_s1_begins_xfer :  STD_LOGIC;
                signal led_pio_s1_end_xfer :  STD_LOGIC;
                signal led_pio_s1_firsttransfer :  STD_LOGIC;
                signal led_pio_s1_grant_vector :  STD_LOGIC;
                signal led_pio_s1_in_a_read_cycle :  STD_LOGIC;
                signal led_pio_s1_in_a_write_cycle :  STD_LOGIC;
                signal led_pio_s1_master_qreq_vector :  STD_LOGIC;
                signal led_pio_s1_non_bursting_master_requests :  STD_LOGIC;
                signal led_pio_s1_reg_firsttransfer :  STD_LOGIC;
                signal led_pio_s1_slavearbiterlockenable :  STD_LOGIC;
                signal led_pio_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal led_pio_s1_unreg_firsttransfer :  STD_LOGIC;
                signal led_pio_s1_waits_for_read :  STD_LOGIC;
                signal led_pio_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_led_pio_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_led_pio_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT led_pio_s1_end_xfer;
    end if;

  end process;

  led_pio_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_led_pio_s1);
  --assign led_pio_s1_readdata_from_sa = led_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  led_pio_s1_readdata_from_sa <= led_pio_s1_readdata;
  internal_cpu_0_data_master_requests_led_pio_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00000000000000000000010000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --led_pio_s1_arb_share_counter set values, which is an e_mux
  led_pio_s1_arb_share_set_values <= std_logic_vector'("01");
  --led_pio_s1_non_bursting_master_requests mux, which is an e_mux
  led_pio_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_led_pio_s1;
  --led_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  led_pio_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --led_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  led_pio_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(led_pio_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (led_pio_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(led_pio_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (led_pio_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --led_pio_s1_allgrants all slave grants, which is an e_mux
  led_pio_s1_allgrants <= led_pio_s1_grant_vector;
  --led_pio_s1_end_xfer assignment, which is an e_assign
  led_pio_s1_end_xfer <= NOT ((led_pio_s1_waits_for_read OR led_pio_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_led_pio_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_led_pio_s1 <= led_pio_s1_end_xfer AND (((NOT led_pio_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --led_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  led_pio_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_led_pio_s1 AND led_pio_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_led_pio_s1 AND NOT led_pio_s1_non_bursting_master_requests));
  --led_pio_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      led_pio_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(led_pio_s1_arb_counter_enable) = '1' then 
        led_pio_s1_arb_share_counter <= led_pio_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --led_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      led_pio_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((led_pio_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_led_pio_s1)) OR ((end_xfer_arb_share_counter_term_led_pio_s1 AND NOT led_pio_s1_non_bursting_master_requests)))) = '1' then 
        led_pio_s1_slavearbiterlockenable <= or_reduce(led_pio_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master led_pio/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= led_pio_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --led_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  led_pio_s1_slavearbiterlockenable2 <= or_reduce(led_pio_s1_arb_share_counter_next_value);
  --cpu_0/data_master led_pio/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= led_pio_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --led_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  led_pio_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_led_pio_s1 <= internal_cpu_0_data_master_requests_led_pio_s1 AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_led_pio_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_led_pio_s1 <= (internal_cpu_0_data_master_granted_led_pio_s1 AND cpu_0_data_master_read) AND NOT led_pio_s1_waits_for_read;
  --led_pio_s1_writedata mux, which is an e_mux
  led_pio_s1_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_led_pio_s1 <= internal_cpu_0_data_master_qualified_request_led_pio_s1;
  --cpu_0/data_master saved-grant led_pio/s1, which is an e_assign
  cpu_0_data_master_saved_grant_led_pio_s1 <= internal_cpu_0_data_master_requests_led_pio_s1;
  --allow new arb cycle for led_pio/s1, which is an e_assign
  led_pio_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  led_pio_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  led_pio_s1_master_qreq_vector <= std_logic'('1');
  --led_pio_s1_reset_n assignment, which is an e_assign
  led_pio_s1_reset_n <= reset_n;
  led_pio_s1_chipselect <= internal_cpu_0_data_master_granted_led_pio_s1;
  --led_pio_s1_firsttransfer first transaction, which is an e_assign
  led_pio_s1_firsttransfer <= A_WE_StdLogic((std_logic'(led_pio_s1_begins_xfer) = '1'), led_pio_s1_unreg_firsttransfer, led_pio_s1_reg_firsttransfer);
  --led_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  led_pio_s1_unreg_firsttransfer <= NOT ((led_pio_s1_slavearbiterlockenable AND led_pio_s1_any_continuerequest));
  --led_pio_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      led_pio_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(led_pio_s1_begins_xfer) = '1' then 
        led_pio_s1_reg_firsttransfer <= led_pio_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --led_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  led_pio_s1_beginbursttransfer_internal <= led_pio_s1_begins_xfer;
  --~led_pio_s1_write_n assignment, which is an e_mux
  led_pio_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_led_pio_s1 AND cpu_0_data_master_write));
  shifted_address_to_led_pio_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --led_pio_s1_address mux, which is an e_mux
  led_pio_s1_address <= A_EXT (A_SRL(shifted_address_to_led_pio_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_led_pio_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_led_pio_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_led_pio_s1_end_xfer <= led_pio_s1_end_xfer;
    end if;

  end process;

  --led_pio_s1_waits_for_read in a cycle, which is an e_mux
  led_pio_s1_waits_for_read <= led_pio_s1_in_a_read_cycle AND led_pio_s1_begins_xfer;
  --led_pio_s1_in_a_read_cycle assignment, which is an e_assign
  led_pio_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_led_pio_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= led_pio_s1_in_a_read_cycle;
  --led_pio_s1_waits_for_write in a cycle, which is an e_mux
  led_pio_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(led_pio_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --led_pio_s1_in_a_write_cycle assignment, which is an e_assign
  led_pio_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_led_pio_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= led_pio_s1_in_a_write_cycle;
  wait_for_led_pio_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_led_pio_s1 <= internal_cpu_0_data_master_granted_led_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_led_pio_s1 <= internal_cpu_0_data_master_qualified_request_led_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_led_pio_s1 <= internal_cpu_0_data_master_requests_led_pio_s1;
--synthesis translate_off
    --led_pio/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module;


architecture europa of rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal full_7 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal p6_full_6 :  STD_LOGIC;
                signal p6_stage_6 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal stage_6 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_6;
  empty <= NOT(full_0);
  full_7 <= std_logic'('0');
  --data_6, which is an e_mux
  p6_stage_6 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_7 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_6))))) = '1' then 
        if std_logic'(((sync_reset AND full_6) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_7))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_6 <= std_logic'('0');
        else
          stage_6 <= p6_stage_6;
        end if;
      end if;
    end if;

  end process;

  --control_6, which is an e_mux
  p6_full_6 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_6 <= std_logic'('0');
        else
          full_6 <= p6_full_6;
        end if;
      end if;
    end if;

  end process;

  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_6);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_4, full_6);
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module;


architecture europa of rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal full_7 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal p6_full_6 :  STD_LOGIC;
                signal p6_stage_6 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal stage_6 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_6;
  empty <= NOT(full_0);
  full_7 <= std_logic'('0');
  --data_6, which is an e_mux
  p6_stage_6 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_7 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_6))))) = '1' then 
        if std_logic'(((sync_reset AND full_6) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_7))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_6 <= std_logic'('0');
        else
          stage_6 <= p6_stage_6;
        end if;
      end if;
    end if;

  end process;

  --control_6, which is an e_mux
  p6_full_6 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_6, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_6 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_6 <= std_logic'('0');
        else
          full_6 <= p6_full_6;
        end if;
      end if;
    end if;

  end process;

  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_6);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_4, full_6);
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity sdram_0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_readdatavalid : IN STD_LOGIC;
                 signal sdram_0_s1_waitrequest : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_byteenable_sdram_0_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                 signal d1_sdram_0_s1_end_xfer : OUT STD_LOGIC;
                 signal sdram_0_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal sdram_0_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sdram_0_s1_chipselect : OUT STD_LOGIC;
                 signal sdram_0_s1_read_n : OUT STD_LOGIC;
                 signal sdram_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_0_s1_reset_n : OUT STD_LOGIC;
                 signal sdram_0_s1_waitrequest_from_sa : OUT STD_LOGIC;
                 signal sdram_0_s1_write_n : OUT STD_LOGIC;
                 signal sdram_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sdram_0_s1_arbitrator;


architecture europa of sdram_0_s1_arbitrator is
component rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module;

component rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module;

                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_byteenable_sdram_0_s1_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sdram_0_s1_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_rdv_fifo_empty_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_sdram_0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sdram_0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_byteenable_sdram_0_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal internal_sdram_0_s1_waitrequest_from_sa :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal module_input3 :  STD_LOGIC;
                signal module_input4 :  STD_LOGIC;
                signal module_input5 :  STD_LOGIC;
                signal sdram_0_s1_allgrants :  STD_LOGIC;
                signal sdram_0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sdram_0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sdram_0_s1_any_continuerequest :  STD_LOGIC;
                signal sdram_0_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_counter_enable :  STD_LOGIC;
                signal sdram_0_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal sdram_0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sdram_0_s1_begins_xfer :  STD_LOGIC;
                signal sdram_0_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal sdram_0_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_end_xfer :  STD_LOGIC;
                signal sdram_0_s1_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_in_a_read_cycle :  STD_LOGIC;
                signal sdram_0_s1_in_a_write_cycle :  STD_LOGIC;
                signal sdram_0_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_move_on_to_next_transaction :  STD_LOGIC;
                signal sdram_0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sdram_0_s1_readdatavalid_from_sa :  STD_LOGIC;
                signal sdram_0_s1_reg_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sdram_0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sdram_0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sdram_0_s1_waits_for_read :  STD_LOGIC;
                signal sdram_0_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sdram_0_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_sdram_0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sdram_0_s1_end_xfer;
    end if;

  end process;

  sdram_0_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_sdram_0_s1 OR internal_cpu_0_instruction_master_qualified_request_sdram_0_s1));
  --assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_0_s1_readdatavalid_from_sa <= sdram_0_s1_readdatavalid;
  --assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_0_s1_readdata_from_sa <= sdram_0_s1_readdata;
  internal_cpu_0_data_master_requests_sdram_0_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("10000000000000000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_sdram_0_s1_waitrequest_from_sa <= sdram_0_s1_waitrequest;
  --sdram_0_s1_arb_share_counter set values, which is an e_mux
  sdram_0_s1_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sdram_0_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001"))))), 2);
  --sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  sdram_0_s1_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_sdram_0_s1 OR internal_cpu_0_instruction_master_requests_sdram_0_s1) OR internal_cpu_0_data_master_requests_sdram_0_s1) OR internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --sdram_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sdram_0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  sdram_0_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sdram_0_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_0_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sdram_0_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_0_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sdram_0_s1_allgrants all slave grants, which is an e_mux
  sdram_0_s1_allgrants <= (((or_reduce(sdram_0_s1_grant_vector)) OR (or_reduce(sdram_0_s1_grant_vector))) OR (or_reduce(sdram_0_s1_grant_vector))) OR (or_reduce(sdram_0_s1_grant_vector));
  --sdram_0_s1_end_xfer assignment, which is an e_assign
  sdram_0_s1_end_xfer <= NOT ((sdram_0_s1_waits_for_read OR sdram_0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sdram_0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sdram_0_s1 <= sdram_0_s1_end_xfer AND (((NOT sdram_0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sdram_0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sdram_0_s1 AND sdram_0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sdram_0_s1 AND NOT sdram_0_s1_non_bursting_master_requests));
  --sdram_0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_arb_counter_enable) = '1' then 
        sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(sdram_0_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_sdram_0_s1)) OR ((end_xfer_arb_share_counter_term_sdram_0_s1 AND NOT sdram_0_s1_non_bursting_master_requests)))) = '1' then 
        sdram_0_s1_slavearbiterlockenable <= or_reduce(sdram_0_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sdram_0/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sdram_0_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sdram_0_s1_slavearbiterlockenable2 <= or_reduce(sdram_0_s1_arb_share_counter_next_value);
  --cpu_0/data_master sdram_0/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sdram_0_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master sdram_0/s1 arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= sdram_0_s1_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master sdram_0/s1 arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= sdram_0_s1_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted sdram_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_sdram_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_sdram_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 AND internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  sdram_0_s1_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_sdram_0_s1 <= internal_cpu_0_data_master_requests_sdram_0_s1 AND NOT (((((cpu_0_data_master_read AND to_std_logic((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))) OR ((std_logic_vector'("00000000000000000000000000000001")<(std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter)))))))))) OR (((NOT(or_reduce(internal_cpu_0_data_master_byteenable_sdram_0_s1))) AND cpu_0_data_master_write))) OR cpu_0_instruction_master_arbiterlock));
  --unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  sdram_0_s1_move_on_to_next_transaction <= sdram_0_s1_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1 : rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module
    port map(
      data_out => cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1,
      empty => open,
      fifo_contains_ones_n => cpu_0_data_master_rdv_fifo_empty_sdram_0_s1,
      full => open,
      clear_fifo => module_input,
      clk => clk,
      data_in => internal_cpu_0_data_master_granted_sdram_0_s1,
      read => sdram_0_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input1,
      write => module_input2
    );

  module_input <= std_logic'('0');
  module_input1 <= std_logic'('0');
  module_input2 <= in_a_read_cycle AND NOT sdram_0_s1_waits_for_read;

  cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register <= NOT cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  --local readdatavalid cpu_0_data_master_read_data_valid_sdram_0_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_sdram_0_s1 <= ((sdram_0_s1_readdatavalid_from_sa AND cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1)) AND NOT cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  --sdram_0_s1_writedata mux, which is an e_mux
  sdram_0_s1_writedata <= cpu_0_data_master_dbs_write_16;
  internal_cpu_0_instruction_master_requests_sdram_0_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(25 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("10000000000000000000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted sdram_0/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_sdram_0_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_0_s1_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_sdram_0_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 AND internal_cpu_0_data_master_requests_sdram_0_s1;
  internal_cpu_0_instruction_master_qualified_request_sdram_0_s1 <= internal_cpu_0_instruction_master_requests_sdram_0_s1 AND NOT ((((cpu_0_instruction_master_read AND to_std_logic((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))) OR ((std_logic_vector'("00000000000000000000000000000001")<(std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_latency_counter)))))))))) OR cpu_0_data_master_arbiterlock));
  --rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1 : rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module
    port map(
      data_out => cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1,
      empty => open,
      fifo_contains_ones_n => cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1,
      full => open,
      clear_fifo => module_input3,
      clk => clk,
      data_in => internal_cpu_0_instruction_master_granted_sdram_0_s1,
      read => sdram_0_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input4,
      write => module_input5
    );

  module_input3 <= std_logic'('0');
  module_input4 <= std_logic'('0');
  module_input5 <= in_a_read_cycle AND NOT sdram_0_s1_waits_for_read;

  cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register <= NOT cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  --local readdatavalid cpu_0_instruction_master_read_data_valid_sdram_0_s1, which is an e_mux
  cpu_0_instruction_master_read_data_valid_sdram_0_s1 <= ((sdram_0_s1_readdatavalid_from_sa AND cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1)) AND NOT cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  --allow new arb cycle for sdram_0/s1, which is an e_assign
  sdram_0_s1_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  sdram_0_s1_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_sdram_0_s1;
  --cpu_0/instruction_master grant sdram_0/s1, which is an e_assign
  internal_cpu_0_instruction_master_granted_sdram_0_s1 <= sdram_0_s1_grant_vector(0);
  --cpu_0/instruction_master saved-grant sdram_0/s1, which is an e_assign
  cpu_0_instruction_master_saved_grant_sdram_0_s1 <= sdram_0_s1_arb_winner(0) AND internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --cpu_0/data_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  sdram_0_s1_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_sdram_0_s1;
  --cpu_0/data_master grant sdram_0/s1, which is an e_assign
  internal_cpu_0_data_master_granted_sdram_0_s1 <= sdram_0_s1_grant_vector(1);
  --cpu_0/data_master saved-grant sdram_0/s1, which is an e_assign
  cpu_0_data_master_saved_grant_sdram_0_s1 <= sdram_0_s1_arb_winner(1) AND internal_cpu_0_data_master_requests_sdram_0_s1;
  --sdram_0/s1 chosen-master double-vector, which is an e_assign
  sdram_0_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((sdram_0_s1_master_qreq_vector & sdram_0_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT sdram_0_s1_master_qreq_vector & NOT sdram_0_s1_master_qreq_vector))) + (std_logic_vector'("000") & (sdram_0_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  sdram_0_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((sdram_0_s1_allow_new_arb_cycle AND or_reduce(sdram_0_s1_grant_vector)))) = '1'), sdram_0_s1_grant_vector, sdram_0_s1_saved_chosen_master_vector);
  --saved sdram_0_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_allow_new_arb_cycle) = '1' then 
        sdram_0_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(sdram_0_s1_grant_vector)) = '1'), sdram_0_s1_grant_vector, sdram_0_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  sdram_0_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((sdram_0_s1_chosen_master_double_vector(1) OR sdram_0_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((sdram_0_s1_chosen_master_double_vector(0) OR sdram_0_s1_chosen_master_double_vector(2)))));
  --sdram_0/s1 chosen master rotated left, which is an e_assign
  sdram_0_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(sdram_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(sdram_0_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --sdram_0/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(sdram_0_s1_grant_vector)) = '1' then 
        sdram_0_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(sdram_0_s1_end_xfer) = '1'), sdram_0_s1_chosen_master_rot_left, sdram_0_s1_grant_vector);
      end if;
    end if;

  end process;

  --sdram_0_s1_reset_n assignment, which is an e_assign
  sdram_0_s1_reset_n <= reset_n;
  sdram_0_s1_chipselect <= internal_cpu_0_data_master_granted_sdram_0_s1 OR internal_cpu_0_instruction_master_granted_sdram_0_s1;
  --sdram_0_s1_firsttransfer first transaction, which is an e_assign
  sdram_0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sdram_0_s1_begins_xfer) = '1'), sdram_0_s1_unreg_firsttransfer, sdram_0_s1_reg_firsttransfer);
  --sdram_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  sdram_0_s1_unreg_firsttransfer <= NOT ((sdram_0_s1_slavearbiterlockenable AND sdram_0_s1_any_continuerequest));
  --sdram_0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_0_s1_begins_xfer) = '1' then 
        sdram_0_s1_reg_firsttransfer <= sdram_0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sdram_0_s1_beginbursttransfer_internal <= sdram_0_s1_begins_xfer;
  --sdram_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  sdram_0_s1_arbitration_holdoff_internal <= sdram_0_s1_begins_xfer AND sdram_0_s1_firsttransfer;
  --~sdram_0_s1_read_n assignment, which is an e_mux
  sdram_0_s1_read_n <= NOT ((((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sdram_0_s1 AND cpu_0_instruction_master_read))));
  --~sdram_0_s1_write_n assignment, which is an e_mux
  sdram_0_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write));
  shifted_address_to_sdram_0_s1_from_cpu_0_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 26);
  --sdram_0_s1_address mux, which is an e_mux
  sdram_0_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), (A_SRL(shifted_address_to_sdram_0_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000001"))), (A_SRL(shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000001")))), 22);
  shifted_address_to_sdram_0_s1_from_cpu_0_instruction_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_instruction_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 26);
  --d1_sdram_0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sdram_0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end if;

  end process;

  --sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  sdram_0_s1_waits_for_read <= sdram_0_s1_in_a_read_cycle AND internal_sdram_0_s1_waitrequest_from_sa;
  --sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  sdram_0_s1_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sdram_0_s1 AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sdram_0_s1_in_a_read_cycle;
  --sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  sdram_0_s1_waits_for_write <= sdram_0_s1_in_a_write_cycle AND internal_sdram_0_s1_waitrequest_from_sa;
  --sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  sdram_0_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_sdram_0_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sdram_0_s1_in_a_write_cycle;
  wait_for_sdram_0_s1_counter <= std_logic'('0');
  --~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  sdram_0_s1_byteenable_n <= A_EXT (NOT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdram_0_s1)) = '1'), (std_logic_vector'("000000000000000000000000000000") & (internal_cpu_0_data_master_byteenable_sdram_0_s1)), -SIGNED(std_logic_vector'("00000000000000000000000000000001")))), 2);
  (cpu_0_data_master_byteenable_sdram_0_s1_segment_1(1), cpu_0_data_master_byteenable_sdram_0_s1_segment_1(0), cpu_0_data_master_byteenable_sdram_0_s1_segment_0(1), cpu_0_data_master_byteenable_sdram_0_s1_segment_0(0)) <= cpu_0_data_master_byteenable;
  internal_cpu_0_data_master_byteenable_sdram_0_s1 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_0_data_master_byteenable_sdram_0_s1_segment_0, cpu_0_data_master_byteenable_sdram_0_s1_segment_1);
  --vhdl renameroo for output signals
  cpu_0_data_master_byteenable_sdram_0_s1 <= internal_cpu_0_data_master_byteenable_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sdram_0_s1 <= internal_cpu_0_data_master_granted_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sdram_0_s1 <= internal_cpu_0_data_master_qualified_request_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sdram_0_s1 <= internal_cpu_0_data_master_requests_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_sdram_0_s1 <= internal_cpu_0_instruction_master_granted_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_sdram_0_s1 <= internal_cpu_0_instruction_master_qualified_request_sdram_0_s1;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_sdram_0_s1 <= internal_cpu_0_instruction_master_requests_sdram_0_s1;
  --vhdl renameroo for output signals
  sdram_0_s1_waitrequest_from_sa <= internal_sdram_0_s1_waitrequest_from_sa;
--synthesis translate_off
    --sdram_0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line9 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_sdram_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_sdram_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line9, now);
          write(write_line9, string'(": "));
          write(write_line9, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line9.all);
          deallocate (write_line9);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line10 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_sdram_0_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_sdram_0_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line10, now);
          write(write_line10, string'(": "));
          write(write_line10, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line10.all);
          deallocate (write_line10);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity seven_seg_pio_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal seven_seg_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_seven_seg_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_seven_seg_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_seven_seg_pio_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_seven_seg_pio_s1 : OUT STD_LOGIC;
                 signal d1_seven_seg_pio_s1_end_xfer : OUT STD_LOGIC;
                 signal seven_seg_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal seven_seg_pio_s1_chipselect : OUT STD_LOGIC;
                 signal seven_seg_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal seven_seg_pio_s1_reset_n : OUT STD_LOGIC;
                 signal seven_seg_pio_s1_write_n : OUT STD_LOGIC;
                 signal seven_seg_pio_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity seven_seg_pio_s1_arbitrator;


architecture europa of seven_seg_pio_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_seven_seg_pio_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_seven_seg_pio_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_seven_seg_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_seven_seg_pio_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_seven_seg_pio_s1 :  STD_LOGIC;
                signal seven_seg_pio_s1_allgrants :  STD_LOGIC;
                signal seven_seg_pio_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal seven_seg_pio_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal seven_seg_pio_s1_any_continuerequest :  STD_LOGIC;
                signal seven_seg_pio_s1_arb_counter_enable :  STD_LOGIC;
                signal seven_seg_pio_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal seven_seg_pio_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal seven_seg_pio_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal seven_seg_pio_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal seven_seg_pio_s1_begins_xfer :  STD_LOGIC;
                signal seven_seg_pio_s1_end_xfer :  STD_LOGIC;
                signal seven_seg_pio_s1_firsttransfer :  STD_LOGIC;
                signal seven_seg_pio_s1_grant_vector :  STD_LOGIC;
                signal seven_seg_pio_s1_in_a_read_cycle :  STD_LOGIC;
                signal seven_seg_pio_s1_in_a_write_cycle :  STD_LOGIC;
                signal seven_seg_pio_s1_master_qreq_vector :  STD_LOGIC;
                signal seven_seg_pio_s1_non_bursting_master_requests :  STD_LOGIC;
                signal seven_seg_pio_s1_reg_firsttransfer :  STD_LOGIC;
                signal seven_seg_pio_s1_slavearbiterlockenable :  STD_LOGIC;
                signal seven_seg_pio_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal seven_seg_pio_s1_unreg_firsttransfer :  STD_LOGIC;
                signal seven_seg_pio_s1_waits_for_read :  STD_LOGIC;
                signal seven_seg_pio_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_seven_seg_pio_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_seven_seg_pio_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT seven_seg_pio_s1_end_xfer;
    end if;

  end process;

  seven_seg_pio_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_seven_seg_pio_s1);
  --assign seven_seg_pio_s1_readdata_from_sa = seven_seg_pio_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  seven_seg_pio_s1_readdata_from_sa <= seven_seg_pio_s1_readdata;
  internal_cpu_0_data_master_requests_seven_seg_pio_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00000000000000000000100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --seven_seg_pio_s1_arb_share_counter set values, which is an e_mux
  seven_seg_pio_s1_arb_share_set_values <= std_logic_vector'("01");
  --seven_seg_pio_s1_non_bursting_master_requests mux, which is an e_mux
  seven_seg_pio_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_seven_seg_pio_s1;
  --seven_seg_pio_s1_any_bursting_master_saved_grant mux, which is an e_mux
  seven_seg_pio_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --seven_seg_pio_s1_arb_share_counter_next_value assignment, which is an e_assign
  seven_seg_pio_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(seven_seg_pio_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (seven_seg_pio_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(seven_seg_pio_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (seven_seg_pio_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --seven_seg_pio_s1_allgrants all slave grants, which is an e_mux
  seven_seg_pio_s1_allgrants <= seven_seg_pio_s1_grant_vector;
  --seven_seg_pio_s1_end_xfer assignment, which is an e_assign
  seven_seg_pio_s1_end_xfer <= NOT ((seven_seg_pio_s1_waits_for_read OR seven_seg_pio_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_seven_seg_pio_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_seven_seg_pio_s1 <= seven_seg_pio_s1_end_xfer AND (((NOT seven_seg_pio_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --seven_seg_pio_s1_arb_share_counter arbitration counter enable, which is an e_assign
  seven_seg_pio_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_seven_seg_pio_s1 AND seven_seg_pio_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_seven_seg_pio_s1 AND NOT seven_seg_pio_s1_non_bursting_master_requests));
  --seven_seg_pio_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      seven_seg_pio_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(seven_seg_pio_s1_arb_counter_enable) = '1' then 
        seven_seg_pio_s1_arb_share_counter <= seven_seg_pio_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --seven_seg_pio_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      seven_seg_pio_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((seven_seg_pio_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_seven_seg_pio_s1)) OR ((end_xfer_arb_share_counter_term_seven_seg_pio_s1 AND NOT seven_seg_pio_s1_non_bursting_master_requests)))) = '1' then 
        seven_seg_pio_s1_slavearbiterlockenable <= or_reduce(seven_seg_pio_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master seven_seg_pio/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= seven_seg_pio_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --seven_seg_pio_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  seven_seg_pio_s1_slavearbiterlockenable2 <= or_reduce(seven_seg_pio_s1_arb_share_counter_next_value);
  --cpu_0/data_master seven_seg_pio/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= seven_seg_pio_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --seven_seg_pio_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  seven_seg_pio_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_seven_seg_pio_s1 <= internal_cpu_0_data_master_requests_seven_seg_pio_s1 AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_seven_seg_pio_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_seven_seg_pio_s1 <= (internal_cpu_0_data_master_granted_seven_seg_pio_s1 AND cpu_0_data_master_read) AND NOT seven_seg_pio_s1_waits_for_read;
  --seven_seg_pio_s1_writedata mux, which is an e_mux
  seven_seg_pio_s1_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_seven_seg_pio_s1 <= internal_cpu_0_data_master_qualified_request_seven_seg_pio_s1;
  --cpu_0/data_master saved-grant seven_seg_pio/s1, which is an e_assign
  cpu_0_data_master_saved_grant_seven_seg_pio_s1 <= internal_cpu_0_data_master_requests_seven_seg_pio_s1;
  --allow new arb cycle for seven_seg_pio/s1, which is an e_assign
  seven_seg_pio_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  seven_seg_pio_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  seven_seg_pio_s1_master_qreq_vector <= std_logic'('1');
  --seven_seg_pio_s1_reset_n assignment, which is an e_assign
  seven_seg_pio_s1_reset_n <= reset_n;
  seven_seg_pio_s1_chipselect <= internal_cpu_0_data_master_granted_seven_seg_pio_s1;
  --seven_seg_pio_s1_firsttransfer first transaction, which is an e_assign
  seven_seg_pio_s1_firsttransfer <= A_WE_StdLogic((std_logic'(seven_seg_pio_s1_begins_xfer) = '1'), seven_seg_pio_s1_unreg_firsttransfer, seven_seg_pio_s1_reg_firsttransfer);
  --seven_seg_pio_s1_unreg_firsttransfer first transaction, which is an e_assign
  seven_seg_pio_s1_unreg_firsttransfer <= NOT ((seven_seg_pio_s1_slavearbiterlockenable AND seven_seg_pio_s1_any_continuerequest));
  --seven_seg_pio_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      seven_seg_pio_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(seven_seg_pio_s1_begins_xfer) = '1' then 
        seven_seg_pio_s1_reg_firsttransfer <= seven_seg_pio_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --seven_seg_pio_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  seven_seg_pio_s1_beginbursttransfer_internal <= seven_seg_pio_s1_begins_xfer;
  --~seven_seg_pio_s1_write_n assignment, which is an e_mux
  seven_seg_pio_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_seven_seg_pio_s1 AND cpu_0_data_master_write));
  shifted_address_to_seven_seg_pio_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --seven_seg_pio_s1_address mux, which is an e_mux
  seven_seg_pio_s1_address <= A_EXT (A_SRL(shifted_address_to_seven_seg_pio_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_seven_seg_pio_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_seven_seg_pio_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_seven_seg_pio_s1_end_xfer <= seven_seg_pio_s1_end_xfer;
    end if;

  end process;

  --seven_seg_pio_s1_waits_for_read in a cycle, which is an e_mux
  seven_seg_pio_s1_waits_for_read <= seven_seg_pio_s1_in_a_read_cycle AND seven_seg_pio_s1_begins_xfer;
  --seven_seg_pio_s1_in_a_read_cycle assignment, which is an e_assign
  seven_seg_pio_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_seven_seg_pio_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= seven_seg_pio_s1_in_a_read_cycle;
  --seven_seg_pio_s1_waits_for_write in a cycle, which is an e_mux
  seven_seg_pio_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(seven_seg_pio_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --seven_seg_pio_s1_in_a_write_cycle assignment, which is an e_assign
  seven_seg_pio_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_seven_seg_pio_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= seven_seg_pio_s1_in_a_write_cycle;
  wait_for_seven_seg_pio_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_seven_seg_pio_s1 <= internal_cpu_0_data_master_granted_seven_seg_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_seven_seg_pio_s1 <= internal_cpu_0_data_master_qualified_request_seven_seg_pio_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_seven_seg_pio_s1 <= internal_cpu_0_data_master_requests_seven_seg_pio_s1;
--synthesis translate_off
    --seven_seg_pio/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sys_clk_timer_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sys_clk_timer_s1_irq : IN STD_LOGIC;
                 signal sys_clk_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal d1_sys_clk_timer_s1_end_xfer : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal sys_clk_timer_s1_chipselect : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_irq_from_sa : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sys_clk_timer_s1_reset_n : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_write_n : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sys_clk_timer_s1_arbitrator;


architecture europa of sys_clk_timer_s1_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sys_clk_timer_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sys_clk_timer_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_sys_clk_timer_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sys_clk_timer_s1 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sys_clk_timer_s1 :  STD_LOGIC;
                signal shifted_address_to_sys_clk_timer_s1_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal sys_clk_timer_s1_allgrants :  STD_LOGIC;
                signal sys_clk_timer_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sys_clk_timer_s1_any_continuerequest :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_counter_enable :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sys_clk_timer_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sys_clk_timer_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sys_clk_timer_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sys_clk_timer_s1_begins_xfer :  STD_LOGIC;
                signal sys_clk_timer_s1_end_xfer :  STD_LOGIC;
                signal sys_clk_timer_s1_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_grant_vector :  STD_LOGIC;
                signal sys_clk_timer_s1_in_a_read_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_in_a_write_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_master_qreq_vector :  STD_LOGIC;
                signal sys_clk_timer_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sys_clk_timer_s1_reg_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sys_clk_timer_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sys_clk_timer_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_waits_for_read :  STD_LOGIC;
                signal sys_clk_timer_s1_waits_for_write :  STD_LOGIC;
                signal wait_for_sys_clk_timer_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sys_clk_timer_s1_end_xfer;
    end if;

  end process;

  sys_clk_timer_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_sys_clk_timer_s1);
  --assign sys_clk_timer_s1_readdata_from_sa = sys_clk_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sys_clk_timer_s1_readdata_from_sa <= sys_clk_timer_s1_readdata;
  internal_cpu_0_data_master_requests_sys_clk_timer_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("00000000000000000001000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --sys_clk_timer_s1_arb_share_counter set values, which is an e_mux
  sys_clk_timer_s1_arb_share_set_values <= std_logic_vector'("01");
  --sys_clk_timer_s1_non_bursting_master_requests mux, which is an e_mux
  sys_clk_timer_s1_non_bursting_master_requests <= internal_cpu_0_data_master_requests_sys_clk_timer_s1;
  --sys_clk_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sys_clk_timer_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sys_clk_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  sys_clk_timer_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sys_clk_timer_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sys_clk_timer_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sys_clk_timer_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sys_clk_timer_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sys_clk_timer_s1_allgrants all slave grants, which is an e_mux
  sys_clk_timer_s1_allgrants <= sys_clk_timer_s1_grant_vector;
  --sys_clk_timer_s1_end_xfer assignment, which is an e_assign
  sys_clk_timer_s1_end_xfer <= NOT ((sys_clk_timer_s1_waits_for_read OR sys_clk_timer_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sys_clk_timer_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sys_clk_timer_s1 <= sys_clk_timer_s1_end_xfer AND (((NOT sys_clk_timer_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sys_clk_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sys_clk_timer_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND sys_clk_timer_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND NOT sys_clk_timer_s1_non_bursting_master_requests));
  --sys_clk_timer_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sys_clk_timer_s1_arb_counter_enable) = '1' then 
        sys_clk_timer_s1_arb_share_counter <= sys_clk_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sys_clk_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sys_clk_timer_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sys_clk_timer_s1)) OR ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND NOT sys_clk_timer_s1_non_bursting_master_requests)))) = '1' then 
        sys_clk_timer_s1_slavearbiterlockenable <= or_reduce(sys_clk_timer_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sys_clk_timer/s1 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sys_clk_timer_s1_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sys_clk_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sys_clk_timer_s1_slavearbiterlockenable2 <= or_reduce(sys_clk_timer_s1_arb_share_counter_next_value);
  --cpu_0/data_master sys_clk_timer/s1 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sys_clk_timer_s1_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --sys_clk_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sys_clk_timer_s1_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_sys_clk_timer_s1 <= internal_cpu_0_data_master_requests_sys_clk_timer_s1 AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_sys_clk_timer_s1, which is an e_mux
  cpu_0_data_master_read_data_valid_sys_clk_timer_s1 <= (internal_cpu_0_data_master_granted_sys_clk_timer_s1 AND cpu_0_data_master_read) AND NOT sys_clk_timer_s1_waits_for_read;
  --sys_clk_timer_s1_writedata mux, which is an e_mux
  sys_clk_timer_s1_writedata <= cpu_0_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_0_data_master_granted_sys_clk_timer_s1 <= internal_cpu_0_data_master_qualified_request_sys_clk_timer_s1;
  --cpu_0/data_master saved-grant sys_clk_timer/s1, which is an e_assign
  cpu_0_data_master_saved_grant_sys_clk_timer_s1 <= internal_cpu_0_data_master_requests_sys_clk_timer_s1;
  --allow new arb cycle for sys_clk_timer/s1, which is an e_assign
  sys_clk_timer_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sys_clk_timer_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sys_clk_timer_s1_master_qreq_vector <= std_logic'('1');
  --sys_clk_timer_s1_reset_n assignment, which is an e_assign
  sys_clk_timer_s1_reset_n <= reset_n;
  sys_clk_timer_s1_chipselect <= internal_cpu_0_data_master_granted_sys_clk_timer_s1;
  --sys_clk_timer_s1_firsttransfer first transaction, which is an e_assign
  sys_clk_timer_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sys_clk_timer_s1_begins_xfer) = '1'), sys_clk_timer_s1_unreg_firsttransfer, sys_clk_timer_s1_reg_firsttransfer);
  --sys_clk_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  sys_clk_timer_s1_unreg_firsttransfer <= NOT ((sys_clk_timer_s1_slavearbiterlockenable AND sys_clk_timer_s1_any_continuerequest));
  --sys_clk_timer_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sys_clk_timer_s1_begins_xfer) = '1' then 
        sys_clk_timer_s1_reg_firsttransfer <= sys_clk_timer_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sys_clk_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sys_clk_timer_s1_beginbursttransfer_internal <= sys_clk_timer_s1_begins_xfer;
  --~sys_clk_timer_s1_write_n assignment, which is an e_mux
  sys_clk_timer_s1_write_n <= NOT ((internal_cpu_0_data_master_granted_sys_clk_timer_s1 AND cpu_0_data_master_write));
  shifted_address_to_sys_clk_timer_s1_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --sys_clk_timer_s1_address mux, which is an e_mux
  sys_clk_timer_s1_address <= A_EXT (A_SRL(shifted_address_to_sys_clk_timer_s1_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_sys_clk_timer_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sys_clk_timer_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sys_clk_timer_s1_end_xfer <= sys_clk_timer_s1_end_xfer;
    end if;

  end process;

  --sys_clk_timer_s1_waits_for_read in a cycle, which is an e_mux
  sys_clk_timer_s1_waits_for_read <= sys_clk_timer_s1_in_a_read_cycle AND sys_clk_timer_s1_begins_xfer;
  --sys_clk_timer_s1_in_a_read_cycle assignment, which is an e_assign
  sys_clk_timer_s1_in_a_read_cycle <= internal_cpu_0_data_master_granted_sys_clk_timer_s1 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sys_clk_timer_s1_in_a_read_cycle;
  --sys_clk_timer_s1_waits_for_write in a cycle, which is an e_mux
  sys_clk_timer_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sys_clk_timer_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sys_clk_timer_s1_in_a_write_cycle assignment, which is an e_assign
  sys_clk_timer_s1_in_a_write_cycle <= internal_cpu_0_data_master_granted_sys_clk_timer_s1 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sys_clk_timer_s1_in_a_write_cycle;
  wait_for_sys_clk_timer_s1_counter <= std_logic'('0');
  --assign sys_clk_timer_s1_irq_from_sa = sys_clk_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  sys_clk_timer_s1_irq_from_sa <= sys_clk_timer_s1_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sys_clk_timer_s1 <= internal_cpu_0_data_master_granted_sys_clk_timer_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sys_clk_timer_s1 <= internal_cpu_0_data_master_qualified_request_sys_clk_timer_s1;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sys_clk_timer_s1 <= internal_cpu_0_data_master_requests_sys_clk_timer_s1;
--synthesis translate_off
    --sys_clk_timer/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sysid_control_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sysid_control_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sysid_control_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sysid_control_slave : OUT STD_LOGIC;
                 signal d1_sysid_control_slave_end_xfer : OUT STD_LOGIC;
                 signal sysid_control_slave_address : OUT STD_LOGIC;
                 signal sysid_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sysid_control_slave_reset_n : OUT STD_LOGIC
              );
end entity sysid_control_slave_arbitrator;


architecture europa of sysid_control_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sysid_control_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sysid_control_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_sysid_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sysid_control_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sysid_control_slave :  STD_LOGIC;
                signal shifted_address_to_sysid_control_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal sysid_control_slave_allgrants :  STD_LOGIC;
                signal sysid_control_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal sysid_control_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sysid_control_slave_any_continuerequest :  STD_LOGIC;
                signal sysid_control_slave_arb_counter_enable :  STD_LOGIC;
                signal sysid_control_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sysid_control_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal sysid_control_slave_begins_xfer :  STD_LOGIC;
                signal sysid_control_slave_end_xfer :  STD_LOGIC;
                signal sysid_control_slave_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_grant_vector :  STD_LOGIC;
                signal sysid_control_slave_in_a_read_cycle :  STD_LOGIC;
                signal sysid_control_slave_in_a_write_cycle :  STD_LOGIC;
                signal sysid_control_slave_master_qreq_vector :  STD_LOGIC;
                signal sysid_control_slave_non_bursting_master_requests :  STD_LOGIC;
                signal sysid_control_slave_reg_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_slavearbiterlockenable :  STD_LOGIC;
                signal sysid_control_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal sysid_control_slave_unreg_firsttransfer :  STD_LOGIC;
                signal sysid_control_slave_waits_for_read :  STD_LOGIC;
                signal sysid_control_slave_waits_for_write :  STD_LOGIC;
                signal wait_for_sysid_control_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sysid_control_slave_end_xfer;
    end if;

  end process;

  sysid_control_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_sysid_control_slave);
  --assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sysid_control_slave_readdata_from_sa <= sysid_control_slave_readdata;
  internal_cpu_0_data_master_requests_sysid_control_slave <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(25 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("00000000000000000000001000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write)))) AND cpu_0_data_master_read;
  --sysid_control_slave_arb_share_counter set values, which is an e_mux
  sysid_control_slave_arb_share_set_values <= std_logic_vector'("01");
  --sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  sysid_control_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_sysid_control_slave;
  --sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  sysid_control_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  sysid_control_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sysid_control_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sysid_control_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sysid_control_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sysid_control_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sysid_control_slave_allgrants all slave grants, which is an e_mux
  sysid_control_slave_allgrants <= sysid_control_slave_grant_vector;
  --sysid_control_slave_end_xfer assignment, which is an e_assign
  sysid_control_slave_end_xfer <= NOT ((sysid_control_slave_waits_for_read OR sysid_control_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sysid_control_slave <= sysid_control_slave_end_xfer AND (((NOT sysid_control_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  sysid_control_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sysid_control_slave AND sysid_control_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_sysid_control_slave AND NOT sysid_control_slave_non_bursting_master_requests));
  --sysid_control_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sysid_control_slave_arb_counter_enable) = '1' then 
        sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sysid_control_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_sysid_control_slave)) OR ((end_xfer_arb_share_counter_term_sysid_control_slave AND NOT sysid_control_slave_non_bursting_master_requests)))) = '1' then 
        sysid_control_slave_slavearbiterlockenable <= or_reduce(sysid_control_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sysid/control_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sysid_control_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sysid_control_slave_slavearbiterlockenable2 <= or_reduce(sysid_control_slave_arb_share_counter_next_value);
  --cpu_0/data_master sysid/control_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sysid_control_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  sysid_control_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave AND NOT ((cpu_0_data_master_read AND ((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register)))));
  --local readdatavalid cpu_0_data_master_read_data_valid_sysid_control_slave, which is an e_mux
  cpu_0_data_master_read_data_valid_sysid_control_slave <= (internal_cpu_0_data_master_granted_sysid_control_slave AND cpu_0_data_master_read) AND NOT sysid_control_slave_waits_for_read;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_sysid_control_slave <= internal_cpu_0_data_master_qualified_request_sysid_control_slave;
  --cpu_0/data_master saved-grant sysid/control_slave, which is an e_assign
  cpu_0_data_master_saved_grant_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave;
  --allow new arb cycle for sysid/control_slave, which is an e_assign
  sysid_control_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sysid_control_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sysid_control_slave_master_qreq_vector <= std_logic'('1');
  --sysid_control_slave_reset_n assignment, which is an e_assign
  sysid_control_slave_reset_n <= reset_n;
  --sysid_control_slave_firsttransfer first transaction, which is an e_assign
  sysid_control_slave_firsttransfer <= A_WE_StdLogic((std_logic'(sysid_control_slave_begins_xfer) = '1'), sysid_control_slave_unreg_firsttransfer, sysid_control_slave_reg_firsttransfer);
  --sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  sysid_control_slave_unreg_firsttransfer <= NOT ((sysid_control_slave_slavearbiterlockenable AND sysid_control_slave_any_continuerequest));
  --sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sysid_control_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sysid_control_slave_begins_xfer) = '1' then 
        sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sysid_control_slave_beginbursttransfer_internal <= sysid_control_slave_begins_xfer;
  shifted_address_to_sysid_control_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --sysid_control_slave_address mux, which is an e_mux
  sysid_control_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_sysid_control_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_sysid_control_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sysid_control_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end if;

  end process;

  --sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  sysid_control_slave_waits_for_read <= sysid_control_slave_in_a_read_cycle AND sysid_control_slave_begins_xfer;
  --sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  sysid_control_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_sysid_control_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sysid_control_slave_in_a_read_cycle;
  --sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  sysid_control_slave_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sysid_control_slave_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  sysid_control_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_sysid_control_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sysid_control_slave_in_a_write_cycle;
  wait_for_sysid_control_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sysid_control_slave <= internal_cpu_0_data_master_granted_sysid_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sysid_control_slave <= internal_cpu_0_data_master_qualified_request_sysid_control_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sysid_control_slave <= internal_cpu_0_data_master_requests_sysid_control_slave;
--synthesis translate_off
    --sysid/control_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity segment_display_reset_clk_0_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity segment_display_reset_clk_0_domain_synch_module;


architecture europa of segment_display_reset_clk_0_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity segment_display is 
        port (
              -- 1) global signals:
                 signal clk_0 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_button_pio
                 signal in_port_to_the_button_pio : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

              -- the_lcd_display
                 signal LCD_E_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_RS_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_RW_from_the_lcd_display : OUT STD_LOGIC;
                 signal LCD_data_to_and_from_the_lcd_display : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_led_pio
                 signal out_port_from_the_led_pio : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_sdram_0
                 signal zs_addr_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                 signal zs_ba_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_cas_n_from_the_sdram_0 : OUT STD_LOGIC;
                 signal zs_cke_from_the_sdram_0 : OUT STD_LOGIC;
                 signal zs_cs_n_from_the_sdram_0 : OUT STD_LOGIC;
                 signal zs_dq_to_and_from_the_sdram_0 : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal zs_dqm_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_ras_n_from_the_sdram_0 : OUT STD_LOGIC;
                 signal zs_we_n_from_the_sdram_0 : OUT STD_LOGIC;

              -- the_seven_seg_pio
                 signal out_port_from_the_seven_seg_pio : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity segment_display;


architecture europa of segment_display is
component button_pio_s1_arbitrator is 
           port (
                 -- inputs:
                    signal button_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal button_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal button_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal button_pio_s1_reset_n : OUT STD_LOGIC;
                    signal cpu_0_data_master_granted_button_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_button_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_button_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_button_pio_s1 : OUT STD_LOGIC;
                    signal d1_button_pio_s1_end_xfer : OUT STD_LOGIC
                 );
end component button_pio_s1_arbitrator;

component button_pio is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component button_pio;

component cpu_0_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_0_jtag_debug_module_arbitrator;

component cpu_0_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal button_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_byteenable_sdram_0_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_button_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_lcd_display_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_led_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_seven_seg_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_button_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_lcd_display_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_led_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_seven_seg_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_button_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_lcd_display_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_led_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_seven_seg_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_button_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_lcd_display_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_led_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_seven_seg_pio_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sysid_control_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_button_pio_s1_end_xfer : IN STD_LOGIC;
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_lcd_display_control_slave_end_xfer : IN STD_LOGIC;
                    signal d1_led_pio_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_seven_seg_pio_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sys_clk_timer_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sysid_control_slave_end_xfer : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal lcd_display_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal lcd_display_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                    signal led_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;
                    signal seven_seg_pio_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sys_clk_timer_s1_irq_from_sa : IN STD_LOGIC;
                    signal sys_clk_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sysid_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : OUT STD_LOGIC;
                    signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_readdatavalid : OUT STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_data_master_arbitrator;

component cpu_0_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sdram_0_s1 : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_waitrequest_from_sa : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_latency_counter : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_readdatavalid : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_instruction_master_arbitrator;

component cpu_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdatavalid : IN STD_LOGIC;
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_readdatavalid : IN STD_LOGIC;
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu_0;

component jtag_uart_0_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_0_avalon_jtag_slave_arbitrator;

component jtag_uart_0 is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart_0;

component lcd_display_control_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal lcd_display_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_lcd_display_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_lcd_display_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_lcd_display_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_lcd_display_control_slave : OUT STD_LOGIC;
                    signal d1_lcd_display_control_slave_end_xfer : OUT STD_LOGIC;
                    signal lcd_display_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal lcd_display_control_slave_begintransfer : OUT STD_LOGIC;
                    signal lcd_display_control_slave_read : OUT STD_LOGIC;
                    signal lcd_display_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal lcd_display_control_slave_reset_n : OUT STD_LOGIC;
                    signal lcd_display_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                    signal lcd_display_control_slave_write : OUT STD_LOGIC;
                    signal lcd_display_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component lcd_display_control_slave_arbitrator;

component lcd_display is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- outputs:
                    signal LCD_E : OUT STD_LOGIC;
                    signal LCD_RS : OUT STD_LOGIC;
                    signal LCD_RW : OUT STD_LOGIC;
                    signal LCD_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component lcd_display;

component led_pio_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal led_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_led_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_led_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_led_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_led_pio_s1 : OUT STD_LOGIC;
                    signal d1_led_pio_s1_end_xfer : OUT STD_LOGIC;
                    signal led_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal led_pio_s1_chipselect : OUT STD_LOGIC;
                    signal led_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal led_pio_s1_reset_n : OUT STD_LOGIC;
                    signal led_pio_s1_write_n : OUT STD_LOGIC;
                    signal led_pio_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component led_pio_s1_arbitrator;

component led_pio is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component led_pio;

component sdram_0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_0_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_readdatavalid : IN STD_LOGIC;
                    signal sdram_0_s1_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_byteenable_sdram_0_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sdram_0_s1 : OUT STD_LOGIC;
                    signal d1_sdram_0_s1_end_xfer : OUT STD_LOGIC;
                    signal sdram_0_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal sdram_0_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sdram_0_s1_chipselect : OUT STD_LOGIC;
                    signal sdram_0_s1_read_n : OUT STD_LOGIC;
                    signal sdram_0_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_0_s1_reset_n : OUT STD_LOGIC;
                    signal sdram_0_s1_waitrequest_from_sa : OUT STD_LOGIC;
                    signal sdram_0_s1_write_n : OUT STD_LOGIC;
                    signal sdram_0_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sdram_0_s1_arbitrator;

component sdram_0 is 
           port (
                 -- inputs:
                    signal az_addr : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal az_be_n : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal az_cs : IN STD_LOGIC;
                    signal az_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal az_rd_n : IN STD_LOGIC;
                    signal az_wr_n : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal za_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal za_valid : OUT STD_LOGIC;
                    signal za_waitrequest : OUT STD_LOGIC;
                    signal zs_addr : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n : OUT STD_LOGIC;
                    signal zs_cke : OUT STD_LOGIC;
                    signal zs_cs_n : OUT STD_LOGIC;
                    signal zs_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal zs_dqm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n : OUT STD_LOGIC;
                    signal zs_we_n : OUT STD_LOGIC
                 );
end component sdram_0;

component seven_seg_pio_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal seven_seg_pio_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_seven_seg_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_seven_seg_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_seven_seg_pio_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_seven_seg_pio_s1 : OUT STD_LOGIC;
                    signal d1_seven_seg_pio_s1_end_xfer : OUT STD_LOGIC;
                    signal seven_seg_pio_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal seven_seg_pio_s1_chipselect : OUT STD_LOGIC;
                    signal seven_seg_pio_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal seven_seg_pio_s1_reset_n : OUT STD_LOGIC;
                    signal seven_seg_pio_s1_write_n : OUT STD_LOGIC;
                    signal seven_seg_pio_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component seven_seg_pio_s1_arbitrator;

component seven_seg_pio is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component seven_seg_pio;

component sys_clk_timer_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sys_clk_timer_s1_irq : IN STD_LOGIC;
                    signal sys_clk_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal d1_sys_clk_timer_s1_end_xfer : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal sys_clk_timer_s1_chipselect : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_irq_from_sa : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sys_clk_timer_s1_reset_n : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_write_n : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sys_clk_timer_s1_arbitrator;

component sys_clk_timer is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sys_clk_timer;

component sysid_control_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_0_data_master_latency_counter : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sysid_control_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sysid_control_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sysid_control_slave : OUT STD_LOGIC;
                    signal d1_sysid_control_slave_end_xfer : OUT STD_LOGIC;
                    signal sysid_control_slave_address : OUT STD_LOGIC;
                    signal sysid_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sysid_control_slave_reset_n : OUT STD_LOGIC
                 );
end component sysid_control_slave_arbitrator;

component sysid is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal clock : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sysid;

component segment_display_reset_clk_0_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component segment_display_reset_clk_0_domain_synch_module;

                signal button_pio_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal button_pio_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal button_pio_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal button_pio_s1_reset_n :  STD_LOGIC;
                signal clk_0_reset_n :  STD_LOGIC;
                signal cpu_0_data_master_address :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sdram_0_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_write_16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal cpu_0_data_master_debugaccess :  STD_LOGIC;
                signal cpu_0_data_master_granted_button_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_lcd_display_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_led_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_seven_seg_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_latency_counter :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_button_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_lcd_display_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_led_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_seven_seg_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_read :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_button_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_lcd_display_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_led_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_seven_seg_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_readdatavalid :  STD_LOGIC;
                signal cpu_0_data_master_requests_button_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_lcd_display_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_led_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_seven_seg_pio_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sysid_control_slave :  STD_LOGIC;
                signal cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal cpu_0_data_master_write :  STD_LOGIC;
                signal cpu_0_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_address :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_granted_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_latency_counter :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_read :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register :  STD_LOGIC;
                signal cpu_0_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_readdatavalid :  STD_LOGIC;
                signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_requests_sdram_0_s1 :  STD_LOGIC;
                signal cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_0_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_button_pio_s1_end_xfer :  STD_LOGIC;
                signal d1_cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_lcd_display_control_slave_end_xfer :  STD_LOGIC;
                signal d1_led_pio_s1_end_xfer :  STD_LOGIC;
                signal d1_sdram_0_s1_end_xfer :  STD_LOGIC;
                signal d1_seven_seg_pio_s1_end_xfer :  STD_LOGIC;
                signal d1_sys_clk_timer_s1_end_xfer :  STD_LOGIC;
                signal d1_sysid_control_slave_end_xfer :  STD_LOGIC;
                signal internal_LCD_E_from_the_lcd_display :  STD_LOGIC;
                signal internal_LCD_RS_from_the_lcd_display :  STD_LOGIC;
                signal internal_LCD_RW_from_the_lcd_display :  STD_LOGIC;
                signal internal_out_port_from_the_led_pio :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_out_port_from_the_seven_seg_pio :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_zs_addr_from_the_sdram_0 :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal internal_zs_ba_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_cas_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_cke_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_cs_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_dqm_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_ras_n_from_the_sdram_0 :  STD_LOGIC;
                signal internal_zs_we_n_from_the_sdram_0 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal lcd_display_control_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal lcd_display_control_slave_begintransfer :  STD_LOGIC;
                signal lcd_display_control_slave_read :  STD_LOGIC;
                signal lcd_display_control_slave_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal lcd_display_control_slave_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal lcd_display_control_slave_reset_n :  STD_LOGIC;
                signal lcd_display_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal lcd_display_control_slave_write :  STD_LOGIC;
                signal lcd_display_control_slave_writedata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal led_pio_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal led_pio_s1_chipselect :  STD_LOGIC;
                signal led_pio_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal led_pio_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal led_pio_s1_reset_n :  STD_LOGIC;
                signal led_pio_s1_write_n :  STD_LOGIC;
                signal led_pio_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input6 :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal sdram_0_s1_address :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal sdram_0_s1_byteenable_n :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_0_s1_chipselect :  STD_LOGIC;
                signal sdram_0_s1_read_n :  STD_LOGIC;
                signal sdram_0_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_0_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_0_s1_readdatavalid :  STD_LOGIC;
                signal sdram_0_s1_reset_n :  STD_LOGIC;
                signal sdram_0_s1_waitrequest :  STD_LOGIC;
                signal sdram_0_s1_waitrequest_from_sa :  STD_LOGIC;
                signal sdram_0_s1_write_n :  STD_LOGIC;
                signal sdram_0_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal seven_seg_pio_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal seven_seg_pio_s1_chipselect :  STD_LOGIC;
                signal seven_seg_pio_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal seven_seg_pio_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal seven_seg_pio_s1_reset_n :  STD_LOGIC;
                signal seven_seg_pio_s1_write_n :  STD_LOGIC;
                signal seven_seg_pio_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sys_clk_timer_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sys_clk_timer_s1_chipselect :  STD_LOGIC;
                signal sys_clk_timer_s1_irq :  STD_LOGIC;
                signal sys_clk_timer_s1_irq_from_sa :  STD_LOGIC;
                signal sys_clk_timer_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sys_clk_timer_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sys_clk_timer_s1_reset_n :  STD_LOGIC;
                signal sys_clk_timer_s1_write_n :  STD_LOGIC;
                signal sys_clk_timer_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sysid_control_slave_address :  STD_LOGIC;
                signal sysid_control_slave_clock :  STD_LOGIC;
                signal sysid_control_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sysid_control_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sysid_control_slave_reset_n :  STD_LOGIC;

begin

  --the_button_pio_s1, which is an e_instance
  the_button_pio_s1 : button_pio_s1_arbitrator
    port map(
      button_pio_s1_address => button_pio_s1_address,
      button_pio_s1_readdata_from_sa => button_pio_s1_readdata_from_sa,
      button_pio_s1_reset_n => button_pio_s1_reset_n,
      cpu_0_data_master_granted_button_pio_s1 => cpu_0_data_master_granted_button_pio_s1,
      cpu_0_data_master_qualified_request_button_pio_s1 => cpu_0_data_master_qualified_request_button_pio_s1,
      cpu_0_data_master_read_data_valid_button_pio_s1 => cpu_0_data_master_read_data_valid_button_pio_s1,
      cpu_0_data_master_requests_button_pio_s1 => cpu_0_data_master_requests_button_pio_s1,
      d1_button_pio_s1_end_xfer => d1_button_pio_s1_end_xfer,
      button_pio_s1_readdata => button_pio_s1_readdata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      reset_n => clk_0_reset_n
    );


  --the_button_pio, which is an e_ptf_instance
  the_button_pio : button_pio
    port map(
      readdata => button_pio_s1_readdata,
      address => button_pio_s1_address,
      clk => clk_0,
      in_port => in_port_to_the_button_pio,
      reset_n => button_pio_s1_reset_n
    );


  --the_cpu_0_jtag_debug_module, which is an e_instance
  the_cpu_0_jtag_debug_module : cpu_0_jtag_debug_module_arbitrator
    port map(
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      cpu_0_jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      cpu_0_jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      cpu_0_jtag_debug_module_chipselect => cpu_0_jtag_debug_module_chipselect,
      cpu_0_jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      cpu_0_jtag_debug_module_reset_n => cpu_0_jtag_debug_module_reset_n,
      cpu_0_jtag_debug_module_resetrequest_from_sa => cpu_0_jtag_debug_module_resetrequest_from_sa,
      cpu_0_jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      cpu_0_jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_debugaccess => cpu_0_data_master_debugaccess,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_latency_counter => cpu_0_instruction_master_latency_counter,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      cpu_0_jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      reset_n => clk_0_reset_n
    );


  --the_cpu_0_data_master, which is an e_instance
  the_cpu_0_data_master : cpu_0_data_master_arbitrator
    port map(
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_irq => cpu_0_data_master_irq,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_readdata => cpu_0_data_master_readdata,
      cpu_0_data_master_readdatavalid => cpu_0_data_master_readdatavalid,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      button_pio_s1_readdata_from_sa => button_pio_s1_readdata_from_sa,
      clk => clk_0,
      cpu_0_data_master_address => cpu_0_data_master_address,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_byteenable_sdram_0_s1 => cpu_0_data_master_byteenable_sdram_0_s1,
      cpu_0_data_master_granted_button_pio_s1 => cpu_0_data_master_granted_button_pio_s1,
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_granted_lcd_display_control_slave => cpu_0_data_master_granted_lcd_display_control_slave,
      cpu_0_data_master_granted_led_pio_s1 => cpu_0_data_master_granted_led_pio_s1,
      cpu_0_data_master_granted_sdram_0_s1 => cpu_0_data_master_granted_sdram_0_s1,
      cpu_0_data_master_granted_seven_seg_pio_s1 => cpu_0_data_master_granted_seven_seg_pio_s1,
      cpu_0_data_master_granted_sys_clk_timer_s1 => cpu_0_data_master_granted_sys_clk_timer_s1,
      cpu_0_data_master_granted_sysid_control_slave => cpu_0_data_master_granted_sysid_control_slave,
      cpu_0_data_master_qualified_request_button_pio_s1 => cpu_0_data_master_qualified_request_button_pio_s1,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_lcd_display_control_slave => cpu_0_data_master_qualified_request_lcd_display_control_slave,
      cpu_0_data_master_qualified_request_led_pio_s1 => cpu_0_data_master_qualified_request_led_pio_s1,
      cpu_0_data_master_qualified_request_sdram_0_s1 => cpu_0_data_master_qualified_request_sdram_0_s1,
      cpu_0_data_master_qualified_request_seven_seg_pio_s1 => cpu_0_data_master_qualified_request_seven_seg_pio_s1,
      cpu_0_data_master_qualified_request_sys_clk_timer_s1 => cpu_0_data_master_qualified_request_sys_clk_timer_s1,
      cpu_0_data_master_qualified_request_sysid_control_slave => cpu_0_data_master_qualified_request_sysid_control_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_button_pio_s1 => cpu_0_data_master_read_data_valid_button_pio_s1,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_lcd_display_control_slave => cpu_0_data_master_read_data_valid_lcd_display_control_slave,
      cpu_0_data_master_read_data_valid_led_pio_s1 => cpu_0_data_master_read_data_valid_led_pio_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1 => cpu_0_data_master_read_data_valid_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_read_data_valid_seven_seg_pio_s1 => cpu_0_data_master_read_data_valid_seven_seg_pio_s1,
      cpu_0_data_master_read_data_valid_sys_clk_timer_s1 => cpu_0_data_master_read_data_valid_sys_clk_timer_s1,
      cpu_0_data_master_read_data_valid_sysid_control_slave => cpu_0_data_master_read_data_valid_sysid_control_slave,
      cpu_0_data_master_requests_button_pio_s1 => cpu_0_data_master_requests_button_pio_s1,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_lcd_display_control_slave => cpu_0_data_master_requests_lcd_display_control_slave,
      cpu_0_data_master_requests_led_pio_s1 => cpu_0_data_master_requests_led_pio_s1,
      cpu_0_data_master_requests_sdram_0_s1 => cpu_0_data_master_requests_sdram_0_s1,
      cpu_0_data_master_requests_seven_seg_pio_s1 => cpu_0_data_master_requests_seven_seg_pio_s1,
      cpu_0_data_master_requests_sys_clk_timer_s1 => cpu_0_data_master_requests_sys_clk_timer_s1,
      cpu_0_data_master_requests_sysid_control_slave => cpu_0_data_master_requests_sysid_control_slave,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_button_pio_s1_end_xfer => d1_button_pio_s1_end_xfer,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      d1_lcd_display_control_slave_end_xfer => d1_lcd_display_control_slave_end_xfer,
      d1_led_pio_s1_end_xfer => d1_led_pio_s1_end_xfer,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      d1_seven_seg_pio_s1_end_xfer => d1_seven_seg_pio_s1_end_xfer,
      d1_sys_clk_timer_s1_end_xfer => d1_sys_clk_timer_s1_end_xfer,
      d1_sysid_control_slave_end_xfer => d1_sysid_control_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      lcd_display_control_slave_readdata_from_sa => lcd_display_control_slave_readdata_from_sa,
      lcd_display_control_slave_wait_counter_eq_0 => lcd_display_control_slave_wait_counter_eq_0,
      led_pio_s1_readdata_from_sa => led_pio_s1_readdata_from_sa,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa,
      seven_seg_pio_s1_readdata_from_sa => seven_seg_pio_s1_readdata_from_sa,
      sys_clk_timer_s1_irq_from_sa => sys_clk_timer_s1_irq_from_sa,
      sys_clk_timer_s1_readdata_from_sa => sys_clk_timer_s1_readdata_from_sa,
      sysid_control_slave_readdata_from_sa => sysid_control_slave_readdata_from_sa
    );


  --the_cpu_0_instruction_master, which is an e_instance
  the_cpu_0_instruction_master : cpu_0_instruction_master_arbitrator
    port map(
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_latency_counter => cpu_0_instruction_master_latency_counter,
      cpu_0_instruction_master_readdata => cpu_0_instruction_master_readdata,
      cpu_0_instruction_master_readdatavalid => cpu_0_instruction_master_readdatavalid,
      cpu_0_instruction_master_waitrequest => cpu_0_instruction_master_waitrequest,
      clk => clk_0,
      cpu_0_instruction_master_address => cpu_0_instruction_master_address,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_sdram_0_s1 => cpu_0_instruction_master_granted_sdram_0_s1,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_sdram_0_s1 => cpu_0_instruction_master_qualified_request_sdram_0_s1,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1 => cpu_0_instruction_master_read_data_valid_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_sdram_0_s1 => cpu_0_instruction_master_requests_sdram_0_s1,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa
    );


  --the_cpu_0, which is an e_ptf_instance
  the_cpu_0 : cpu_0
    port map(
      d_address => cpu_0_data_master_address,
      d_byteenable => cpu_0_data_master_byteenable,
      d_read => cpu_0_data_master_read,
      d_write => cpu_0_data_master_write,
      d_writedata => cpu_0_data_master_writedata,
      i_address => cpu_0_instruction_master_address,
      i_read => cpu_0_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_0_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      clk => clk_0,
      d_irq => cpu_0_data_master_irq,
      d_readdata => cpu_0_data_master_readdata,
      d_readdatavalid => cpu_0_data_master_readdatavalid,
      d_waitrequest => cpu_0_data_master_waitrequest,
      i_readdata => cpu_0_instruction_master_readdata,
      i_readdatavalid => cpu_0_instruction_master_readdatavalid,
      i_waitrequest => cpu_0_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      jtag_debug_module_select => cpu_0_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      reset_n => cpu_0_jtag_debug_module_reset_n
    );


  --the_jtag_uart_0_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_0_avalon_jtag_slave : jtag_uart_0_avalon_jtag_slave_arbitrator
    port map(
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_address => jtag_uart_0_avalon_jtag_slave_address,
      jtag_uart_0_avalon_jtag_slave_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_0_avalon_jtag_slave_reset_n => jtag_uart_0_avalon_jtag_slave_reset_n,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_0_avalon_jtag_slave_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      jtag_uart_0_avalon_jtag_slave_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      jtag_uart_0_avalon_jtag_slave_dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      jtag_uart_0_avalon_jtag_slave_irq => jtag_uart_0_avalon_jtag_slave_irq,
      jtag_uart_0_avalon_jtag_slave_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      jtag_uart_0_avalon_jtag_slave_readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      jtag_uart_0_avalon_jtag_slave_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      reset_n => clk_0_reset_n
    );


  --the_jtag_uart_0, which is an e_ptf_instance
  the_jtag_uart_0 : jtag_uart_0
    port map(
      av_irq => jtag_uart_0_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_0_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      rst_n => jtag_uart_0_avalon_jtag_slave_reset_n
    );


  --the_lcd_display_control_slave, which is an e_instance
  the_lcd_display_control_slave : lcd_display_control_slave_arbitrator
    port map(
      cpu_0_data_master_granted_lcd_display_control_slave => cpu_0_data_master_granted_lcd_display_control_slave,
      cpu_0_data_master_qualified_request_lcd_display_control_slave => cpu_0_data_master_qualified_request_lcd_display_control_slave,
      cpu_0_data_master_read_data_valid_lcd_display_control_slave => cpu_0_data_master_read_data_valid_lcd_display_control_slave,
      cpu_0_data_master_requests_lcd_display_control_slave => cpu_0_data_master_requests_lcd_display_control_slave,
      d1_lcd_display_control_slave_end_xfer => d1_lcd_display_control_slave_end_xfer,
      lcd_display_control_slave_address => lcd_display_control_slave_address,
      lcd_display_control_slave_begintransfer => lcd_display_control_slave_begintransfer,
      lcd_display_control_slave_read => lcd_display_control_slave_read,
      lcd_display_control_slave_readdata_from_sa => lcd_display_control_slave_readdata_from_sa,
      lcd_display_control_slave_reset_n => lcd_display_control_slave_reset_n,
      lcd_display_control_slave_wait_counter_eq_0 => lcd_display_control_slave_wait_counter_eq_0,
      lcd_display_control_slave_write => lcd_display_control_slave_write,
      lcd_display_control_slave_writedata => lcd_display_control_slave_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      lcd_display_control_slave_readdata => lcd_display_control_slave_readdata,
      reset_n => clk_0_reset_n
    );


  --the_lcd_display, which is an e_ptf_instance
  the_lcd_display : lcd_display
    port map(
      LCD_E => internal_LCD_E_from_the_lcd_display,
      LCD_RS => internal_LCD_RS_from_the_lcd_display,
      LCD_RW => internal_LCD_RW_from_the_lcd_display,
      LCD_data => LCD_data_to_and_from_the_lcd_display,
      readdata => lcd_display_control_slave_readdata,
      address => lcd_display_control_slave_address,
      begintransfer => lcd_display_control_slave_begintransfer,
      clk => clk_0,
      read => lcd_display_control_slave_read,
      reset_n => lcd_display_control_slave_reset_n,
      write => lcd_display_control_slave_write,
      writedata => lcd_display_control_slave_writedata
    );


  --the_led_pio_s1, which is an e_instance
  the_led_pio_s1 : led_pio_s1_arbitrator
    port map(
      cpu_0_data_master_granted_led_pio_s1 => cpu_0_data_master_granted_led_pio_s1,
      cpu_0_data_master_qualified_request_led_pio_s1 => cpu_0_data_master_qualified_request_led_pio_s1,
      cpu_0_data_master_read_data_valid_led_pio_s1 => cpu_0_data_master_read_data_valid_led_pio_s1,
      cpu_0_data_master_requests_led_pio_s1 => cpu_0_data_master_requests_led_pio_s1,
      d1_led_pio_s1_end_xfer => d1_led_pio_s1_end_xfer,
      led_pio_s1_address => led_pio_s1_address,
      led_pio_s1_chipselect => led_pio_s1_chipselect,
      led_pio_s1_readdata_from_sa => led_pio_s1_readdata_from_sa,
      led_pio_s1_reset_n => led_pio_s1_reset_n,
      led_pio_s1_write_n => led_pio_s1_write_n,
      led_pio_s1_writedata => led_pio_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      led_pio_s1_readdata => led_pio_s1_readdata,
      reset_n => clk_0_reset_n
    );


  --the_led_pio, which is an e_ptf_instance
  the_led_pio : led_pio
    port map(
      out_port => internal_out_port_from_the_led_pio,
      readdata => led_pio_s1_readdata,
      address => led_pio_s1_address,
      chipselect => led_pio_s1_chipselect,
      clk => clk_0,
      reset_n => led_pio_s1_reset_n,
      write_n => led_pio_s1_write_n,
      writedata => led_pio_s1_writedata
    );


  --the_sdram_0_s1, which is an e_instance
  the_sdram_0_s1 : sdram_0_s1_arbitrator
    port map(
      cpu_0_data_master_byteenable_sdram_0_s1 => cpu_0_data_master_byteenable_sdram_0_s1,
      cpu_0_data_master_granted_sdram_0_s1 => cpu_0_data_master_granted_sdram_0_s1,
      cpu_0_data_master_qualified_request_sdram_0_s1 => cpu_0_data_master_qualified_request_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1 => cpu_0_data_master_read_data_valid_sdram_0_s1,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_requests_sdram_0_s1 => cpu_0_data_master_requests_sdram_0_s1,
      cpu_0_instruction_master_granted_sdram_0_s1 => cpu_0_instruction_master_granted_sdram_0_s1,
      cpu_0_instruction_master_qualified_request_sdram_0_s1 => cpu_0_instruction_master_qualified_request_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1 => cpu_0_instruction_master_read_data_valid_sdram_0_s1,
      cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_instruction_master_requests_sdram_0_s1 => cpu_0_instruction_master_requests_sdram_0_s1,
      d1_sdram_0_s1_end_xfer => d1_sdram_0_s1_end_xfer,
      sdram_0_s1_address => sdram_0_s1_address,
      sdram_0_s1_byteenable_n => sdram_0_s1_byteenable_n,
      sdram_0_s1_chipselect => sdram_0_s1_chipselect,
      sdram_0_s1_read_n => sdram_0_s1_read_n,
      sdram_0_s1_readdata_from_sa => sdram_0_s1_readdata_from_sa,
      sdram_0_s1_reset_n => sdram_0_s1_reset_n,
      sdram_0_s1_waitrequest_from_sa => sdram_0_s1_waitrequest_from_sa,
      sdram_0_s1_write_n => sdram_0_s1_write_n,
      sdram_0_s1_writedata => sdram_0_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_latency_counter => cpu_0_instruction_master_latency_counter,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      reset_n => clk_0_reset_n,
      sdram_0_s1_readdata => sdram_0_s1_readdata,
      sdram_0_s1_readdatavalid => sdram_0_s1_readdatavalid,
      sdram_0_s1_waitrequest => sdram_0_s1_waitrequest
    );


  --the_sdram_0, which is an e_ptf_instance
  the_sdram_0 : sdram_0
    port map(
      za_data => sdram_0_s1_readdata,
      za_valid => sdram_0_s1_readdatavalid,
      za_waitrequest => sdram_0_s1_waitrequest,
      zs_addr => internal_zs_addr_from_the_sdram_0,
      zs_ba => internal_zs_ba_from_the_sdram_0,
      zs_cas_n => internal_zs_cas_n_from_the_sdram_0,
      zs_cke => internal_zs_cke_from_the_sdram_0,
      zs_cs_n => internal_zs_cs_n_from_the_sdram_0,
      zs_dq => zs_dq_to_and_from_the_sdram_0,
      zs_dqm => internal_zs_dqm_from_the_sdram_0,
      zs_ras_n => internal_zs_ras_n_from_the_sdram_0,
      zs_we_n => internal_zs_we_n_from_the_sdram_0,
      az_addr => sdram_0_s1_address,
      az_be_n => sdram_0_s1_byteenable_n,
      az_cs => sdram_0_s1_chipselect,
      az_data => sdram_0_s1_writedata,
      az_rd_n => sdram_0_s1_read_n,
      az_wr_n => sdram_0_s1_write_n,
      clk => clk_0,
      reset_n => sdram_0_s1_reset_n
    );


  --the_seven_seg_pio_s1, which is an e_instance
  the_seven_seg_pio_s1 : seven_seg_pio_s1_arbitrator
    port map(
      cpu_0_data_master_granted_seven_seg_pio_s1 => cpu_0_data_master_granted_seven_seg_pio_s1,
      cpu_0_data_master_qualified_request_seven_seg_pio_s1 => cpu_0_data_master_qualified_request_seven_seg_pio_s1,
      cpu_0_data_master_read_data_valid_seven_seg_pio_s1 => cpu_0_data_master_read_data_valid_seven_seg_pio_s1,
      cpu_0_data_master_requests_seven_seg_pio_s1 => cpu_0_data_master_requests_seven_seg_pio_s1,
      d1_seven_seg_pio_s1_end_xfer => d1_seven_seg_pio_s1_end_xfer,
      seven_seg_pio_s1_address => seven_seg_pio_s1_address,
      seven_seg_pio_s1_chipselect => seven_seg_pio_s1_chipselect,
      seven_seg_pio_s1_readdata_from_sa => seven_seg_pio_s1_readdata_from_sa,
      seven_seg_pio_s1_reset_n => seven_seg_pio_s1_reset_n,
      seven_seg_pio_s1_write_n => seven_seg_pio_s1_write_n,
      seven_seg_pio_s1_writedata => seven_seg_pio_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n,
      seven_seg_pio_s1_readdata => seven_seg_pio_s1_readdata
    );


  --the_seven_seg_pio, which is an e_ptf_instance
  the_seven_seg_pio : seven_seg_pio
    port map(
      out_port => internal_out_port_from_the_seven_seg_pio,
      readdata => seven_seg_pio_s1_readdata,
      address => seven_seg_pio_s1_address,
      chipselect => seven_seg_pio_s1_chipselect,
      clk => clk_0,
      reset_n => seven_seg_pio_s1_reset_n,
      write_n => seven_seg_pio_s1_write_n,
      writedata => seven_seg_pio_s1_writedata
    );


  --the_sys_clk_timer_s1, which is an e_instance
  the_sys_clk_timer_s1 : sys_clk_timer_s1_arbitrator
    port map(
      cpu_0_data_master_granted_sys_clk_timer_s1 => cpu_0_data_master_granted_sys_clk_timer_s1,
      cpu_0_data_master_qualified_request_sys_clk_timer_s1 => cpu_0_data_master_qualified_request_sys_clk_timer_s1,
      cpu_0_data_master_read_data_valid_sys_clk_timer_s1 => cpu_0_data_master_read_data_valid_sys_clk_timer_s1,
      cpu_0_data_master_requests_sys_clk_timer_s1 => cpu_0_data_master_requests_sys_clk_timer_s1,
      d1_sys_clk_timer_s1_end_xfer => d1_sys_clk_timer_s1_end_xfer,
      sys_clk_timer_s1_address => sys_clk_timer_s1_address,
      sys_clk_timer_s1_chipselect => sys_clk_timer_s1_chipselect,
      sys_clk_timer_s1_irq_from_sa => sys_clk_timer_s1_irq_from_sa,
      sys_clk_timer_s1_readdata_from_sa => sys_clk_timer_s1_readdata_from_sa,
      sys_clk_timer_s1_reset_n => sys_clk_timer_s1_reset_n,
      sys_clk_timer_s1_write_n => sys_clk_timer_s1_write_n,
      sys_clk_timer_s1_writedata => sys_clk_timer_s1_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n,
      sys_clk_timer_s1_irq => sys_clk_timer_s1_irq,
      sys_clk_timer_s1_readdata => sys_clk_timer_s1_readdata
    );


  --the_sys_clk_timer, which is an e_ptf_instance
  the_sys_clk_timer : sys_clk_timer
    port map(
      irq => sys_clk_timer_s1_irq,
      readdata => sys_clk_timer_s1_readdata,
      address => sys_clk_timer_s1_address,
      chipselect => sys_clk_timer_s1_chipselect,
      clk => clk_0,
      reset_n => sys_clk_timer_s1_reset_n,
      write_n => sys_clk_timer_s1_write_n,
      writedata => sys_clk_timer_s1_writedata
    );


  --the_sysid_control_slave, which is an e_instance
  the_sysid_control_slave : sysid_control_slave_arbitrator
    port map(
      cpu_0_data_master_granted_sysid_control_slave => cpu_0_data_master_granted_sysid_control_slave,
      cpu_0_data_master_qualified_request_sysid_control_slave => cpu_0_data_master_qualified_request_sysid_control_slave,
      cpu_0_data_master_read_data_valid_sysid_control_slave => cpu_0_data_master_read_data_valid_sysid_control_slave,
      cpu_0_data_master_requests_sysid_control_slave => cpu_0_data_master_requests_sysid_control_slave,
      d1_sysid_control_slave_end_xfer => d1_sysid_control_slave_end_xfer,
      sysid_control_slave_address => sysid_control_slave_address,
      sysid_control_slave_readdata_from_sa => sysid_control_slave_readdata_from_sa,
      sysid_control_slave_reset_n => sysid_control_slave_reset_n,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_latency_counter => cpu_0_data_master_latency_counter,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register => cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
      cpu_0_data_master_write => cpu_0_data_master_write,
      reset_n => clk_0_reset_n,
      sysid_control_slave_readdata => sysid_control_slave_readdata
    );


  --the_sysid, which is an e_ptf_instance
  the_sysid : sysid
    port map(
      readdata => sysid_control_slave_readdata,
      address => sysid_control_slave_address,
      clock => sysid_control_slave_clock,
      reset_n => sysid_control_slave_reset_n
    );


  --reset is asserted asynchronously and deasserted synchronously
  segment_display_reset_clk_0_domain_synch : segment_display_reset_clk_0_domain_synch_module
    port map(
      data_out => clk_0_reset_n,
      clk => clk_0,
      data_in => module_input6,
      reset_n => reset_n_sources
    );

  module_input6 <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa))))));
  --sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  sysid_control_slave_clock <= std_logic'('0');
  --vhdl renameroo for output signals
  LCD_E_from_the_lcd_display <= internal_LCD_E_from_the_lcd_display;
  --vhdl renameroo for output signals
  LCD_RS_from_the_lcd_display <= internal_LCD_RS_from_the_lcd_display;
  --vhdl renameroo for output signals
  LCD_RW_from_the_lcd_display <= internal_LCD_RW_from_the_lcd_display;
  --vhdl renameroo for output signals
  out_port_from_the_led_pio <= internal_out_port_from_the_led_pio;
  --vhdl renameroo for output signals
  out_port_from_the_seven_seg_pio <= internal_out_port_from_the_seven_seg_pio;
  --vhdl renameroo for output signals
  zs_addr_from_the_sdram_0 <= internal_zs_addr_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_ba_from_the_sdram_0 <= internal_zs_ba_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cas_n_from_the_sdram_0 <= internal_zs_cas_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cke_from_the_sdram_0 <= internal_zs_cke_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_cs_n_from_the_sdram_0 <= internal_zs_cs_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_dqm_from_the_sdram_0 <= internal_zs_dqm_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_ras_n_from_the_sdram_0 <= internal_zs_ras_n_from_the_sdram_0;
  --vhdl renameroo for output signals
  zs_we_n_from_the_sdram_0 <= internal_zs_we_n_from_the_sdram_0;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component segment_display is 
           port (
                 -- 1) global signals:
                    signal clk_0 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_button_pio
                    signal in_port_to_the_button_pio : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

                 -- the_lcd_display
                    signal LCD_E_from_the_lcd_display : OUT STD_LOGIC;
                    signal LCD_RS_from_the_lcd_display : OUT STD_LOGIC;
                    signal LCD_RW_from_the_lcd_display : OUT STD_LOGIC;
                    signal LCD_data_to_and_from_the_lcd_display : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_led_pio
                    signal out_port_from_the_led_pio : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_sdram_0
                    signal zs_addr_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_cke_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_cs_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_dq_to_and_from_the_sdram_0 : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal zs_dqm_from_the_sdram_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n_from_the_sdram_0 : OUT STD_LOGIC;
                    signal zs_we_n_from_the_sdram_0 : OUT STD_LOGIC;

                 -- the_seven_seg_pio
                    signal out_port_from_the_seven_seg_pio : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component segment_display;

                signal LCD_E_from_the_lcd_display :  STD_LOGIC;
                signal LCD_RS_from_the_lcd_display :  STD_LOGIC;
                signal LCD_RW_from_the_lcd_display :  STD_LOGIC;
                signal LCD_data_to_and_from_the_lcd_display :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk :  STD_LOGIC;
                signal clk_0 :  STD_LOGIC;
                signal in_port_to_the_button_pio :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal out_port_from_the_led_pio :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal out_port_from_the_seven_seg_pio :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal reset_n :  STD_LOGIC;
                signal sysid_control_slave_clock :  STD_LOGIC;
                signal zs_addr_from_the_sdram_0 :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal zs_ba_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_cas_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_cke_from_the_sdram_0 :  STD_LOGIC;
                signal zs_cs_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_dq_to_and_from_the_sdram_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal zs_dqm_from_the_sdram_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_ras_n_from_the_sdram_0 :  STD_LOGIC;
                signal zs_we_n_from_the_sdram_0 :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : segment_display
    port map(
      LCD_E_from_the_lcd_display => LCD_E_from_the_lcd_display,
      LCD_RS_from_the_lcd_display => LCD_RS_from_the_lcd_display,
      LCD_RW_from_the_lcd_display => LCD_RW_from_the_lcd_display,
      LCD_data_to_and_from_the_lcd_display => LCD_data_to_and_from_the_lcd_display,
      out_port_from_the_led_pio => out_port_from_the_led_pio,
      out_port_from_the_seven_seg_pio => out_port_from_the_seven_seg_pio,
      zs_addr_from_the_sdram_0 => zs_addr_from_the_sdram_0,
      zs_ba_from_the_sdram_0 => zs_ba_from_the_sdram_0,
      zs_cas_n_from_the_sdram_0 => zs_cas_n_from_the_sdram_0,
      zs_cke_from_the_sdram_0 => zs_cke_from_the_sdram_0,
      zs_cs_n_from_the_sdram_0 => zs_cs_n_from_the_sdram_0,
      zs_dq_to_and_from_the_sdram_0 => zs_dq_to_and_from_the_sdram_0,
      zs_dqm_from_the_sdram_0 => zs_dqm_from_the_sdram_0,
      zs_ras_n_from_the_sdram_0 => zs_ras_n_from_the_sdram_0,
      zs_we_n_from_the_sdram_0 => zs_we_n_from_the_sdram_0,
      clk_0 => clk_0,
      in_port_to_the_button_pio => in_port_to_the_button_pio,
      reset_n => reset_n
    );


  process
  begin
    clk_0 <= '0';
    loop
       wait for 10 ns;
       clk_0 <= not clk_0;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
