module apb_assertions (apb_if vif);

    // Write must be followed by enable
    property apb_write_check;
        @(posedge vif.PCLK)
        (vif.PSEL && vif.PWRITE && !vif.PENABLE)
        |-> ##1 vif.PENABLE;
    endproperty

    assert property (apb_write_check)
        else $error("APB WRITE protocol violated");

    // PSEL should stay high during transaction
    property psel_stable;
        @(posedge vif.PCLK)
        vif.PSEL |-> ##1 vif.PSEL;
    endproperty

    assert property (psel_stable)
        else $error("PSEL dropped unexpectedly");

endmodule