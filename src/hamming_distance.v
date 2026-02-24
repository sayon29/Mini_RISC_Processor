module hamming_unit (
    input wire [31:0] src1,
    output wire [5:0] ham_out
);
    function [5:0] popcount;
        input [31:0] val;
        integer j;
        begin
            popcount = 0;
            for (j = 0; j < 32; j = j + 1) begin
                if (val[j] == 1'b1) begin
                    popcount = popcount + 1;
                end
            end
        end
    endfunction

    assign ham_out = popcount(src1);
endmodule
