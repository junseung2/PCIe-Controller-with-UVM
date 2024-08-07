//////////////////////////////////////////////////////////////////////////////////
// Company: Sungkyunkwan University
// Author:  Junseung Lee 
// E-mail:  junseung0728@naver.com

// Project Name: Simple PCIe Controller 
// Design Name:  PCIe Transaction Layer
// Module Name:  PCIe_TL_RX
//////////////////////////////////////////////////////////////////////////////////

module PCIe_TL_RX
(
    input  wire                                             clk,            // Clock signal
    input  wire                                             rst_n,          // Active-low reset signal

    // Flow control interface
    input  wire                                             fc_valid_i,     // Flow control valid input

    // AXI Read Interface (Slave)
    AXI_AR_CH.slave                                         ar_ch,          // AXI read address channel (slave)
    AXI_R_CH.slave                                          r_ch,           // AXI read data channel (slave)

    // Data Link Layer Interface
    input  wire                                             tlp_valid_i,    // TLP valid input signal
    input  wire [PCIe_PKG::PCIe_TL_TLP_PACKET_SIZE-1:0]     tlp_i, // TLP data input
    output logic                                            tlp_ready_o,    // TLP ready output signal

    // Output TLP Header Array
    output PCIe_PKG::tlp_memory_header                      tlp_hdr_arr_o   // TLP header array output
);
    import PCIe_PKG::*;

    // Internal signals (TLP Header & TLP Data)
    logic [PCIe_PKG::PCIe_DATA_PAYLOAD_SIZE:0]          tlp_data, tlp_data_n;         // TLP data and next TLP data
    PCIe_PKG::tlp_memory_header                         tlp_header, tlp_header_n;     // TLP header and next TLP header

    // VC FIFO signals
    logic                                               vc0_fifo_full, vc0_fifo_empty;    // VC0 FIFO full and empty signals
    logic                                               vc1_fifo_full, vc1_fifo_empty;    // VC1 FIFO full and empty signals
    logic                                               vc0_fifo_wren, vc0_fifo_rden;     // VC0 FIFO write enable and read enable
    logic                                               vc1_fifo_wren, vc1_fifo_rden;     // VC1 FIFO write enable and read enable
    logic [PCIe_PKG::PCIe_TL_TLP_PACKET_SIZE-1:0]       vc0_fifo_rdata;                   // VC0 FIFO read data
    logic [PCIe_PKG::PCIe_TL_TLP_PACKET_SIZE-1:0]       vc1_fifo_rdata;                   // VC1 FIFO read data
    logic [PCIe_PKG::PCIe_TL_TLP_PACKET_SIZE-1:0]       vc0_fifo_wdata;                   // VC0 FIFO write data
    logic [PCIe_PKG::PCIe_TL_TLP_PACKET_SIZE-1:0]       vc1_fifo_wdata;                   // VC1 FIFO write data

    /* Fill the code here */






    

    // Instantiate VC0 FIFO
    PCIe_FIFO vc0 (
        .clk(clk),
        .rst_n(rst_n),
        .full_o(vc0_fifo_full),
        .wren_i(vc0_fifo_wren),
        .wdata_i(vc0_fifo_wdata),
        .empty_o(vc0_fifo_empty),
        .rden_i(vc0_fifo_rden),
        .rdata_o(vc0_fifo_rdata)
    );

    // Instantiate VC1 FIFO
    PCIe_FIFO vc1 (
        .clk(clk),
        .rst_n(rst_n),
        .full_o(vc1_fifo_full),
        .wren_i(vc1_fifo_wren),
        .wdata_i(vc1_fifo_wdata),
        .empty_o(vc1_fifo_empty),
        .rden_i(vc1_fifo_rden),
        .rdata_o(vc1_fifo_rdata)
    );

    // Instantiate PCIe_arbiter
    PCIe_arbiter arbiter (
        .clk(clk),
        .rst_n(rst_n),
        .vc0_empty(vc0_fifo_empty),
        .vc0_rdata(vc0_fifo_rdata),
        .vc1_empty(vc1_fifo_empty),
        .vc1_rdata(vc1_fifo_rdata),
        .tlp_ready_i(r_ch.rready),  // Use AXI read channel ready signal
        .fc_valid_i(fc_valid_i),
        .vc0_rden(vc0_fifo_rden),
        .vc1_rden(vc1_fifo_rden),
        .tlp_valid_o(r_ch.rvalid),   // Use AXI read channel valid signal
        .tlp_o(r_ch.rdata)           // Use AXI read channel data signal
    );

endmodule
