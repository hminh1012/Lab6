  --Example instantiation for system 'segment_display'
  segment_display_inst : segment_display
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


