module clk_divider(
    input clk,
    output out_clk
    );
	reg temp = 0;
	integer k = 0;
  	//reg out_clk = 0;
always @(posedge clk)
begin 
  if (k==24)
  begin
    k=0;
    temp=~temp;
  end
  else
    k = k + 1;

  end
  
assign out_clk = temp;

endmodule