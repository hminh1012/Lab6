  --Example instantiation for system 'sevenseg'
  sevenseg_inst : sevenseg
    port map(
      out_port_from_the_led_pio => out_port_from_the_led_pio,
      out_port_from_the_seven_seg_pio => out_port_from_the_seven_seg_pio,
      clk_0 => clk_0,
      reset_n => reset_n
    );


