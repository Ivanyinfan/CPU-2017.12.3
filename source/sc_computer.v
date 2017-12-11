/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (resetn,clock,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk);
// 定义顶层模块sc_computer，作为工程文件的顶层入口，如图1-1建立工程时指定。
   input resetn,clock,mem_clk;
	// 定义整个计算机module和外界交互的输入信号，包括复位信号resetn、时钟信号clock、
	// 以及一个频率是clock两倍的mem_clk信号。注：resetn 是低电平（neg）有效信号。
	// 这些信号都可以用作仿真验证时的输出观察信号。
   output [31:0] pc,inst,aluout,memout;
	// 模块用于仿真输出的观察信号。缺省为wire型。
   output        imem_clk,dmem_clk;
	//模块用于仿真输出的观察信号, 用于观察验证指令ROM和数据RAM的读写时序。
   wire   [31:0] data;
   wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
   
   sc_cpu cpu (clock,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
	// 实例化了一个CPU模块，其内部又包含运算器ALU模块、控制器CU模块等。
	// 在CPU模块的原型定义sc_cpu模块中，可看到其内部的各模块构成。
   sc_instmem  imem (pc,inst,clock,mem_clk,imem_clk);                  // instruction memory.
	// 实例化指令ROM存储器imem模块。模块原型由sc_instmem定义。
	//
	// 由于Altera的Cyclone系列FPGA只能支持同步的ROM和RAM，读取操作需要时钟信号。
	// 示例代码中是采用Altera公司quartus提供的ROM宏模块lpm_rom实现的，需要读取时钟，
	// 该imem_clk读取时钟由clock信号和mem_clk信号组合而成，具体时序可参考模块内的
	// 相应代码。为什么这样设计，详细设计原理参见本节【问题2】解答。
	// 同时，imem_clk信号作为模块输出信号供仿真器进行观察。
	// 宏模块lpm_rom的时序要求参见其时序图。
   sc_datamem  dmem (aluout,data,memout,wmem,clock,mem_clk,dmem_clk ); // data memory.
	// 数据RAM存储器dmem模块。模块原型由sc_datamem定义。
	// 由于Altera的Cyclone系列FPGA只能支持同步的ROM和RAM，读取操作需要时钟信号。
	// 示例代码中是采用Altera公司quartus提供的RAM宏模块lpm_ram_dq实现的，需要读写时钟，
	// 该dmem_clk读写时钟由clock信号和mem_clk信号组合而成，具体时序可参考模块内的
	// 相应代码。为什么这样设计，详细设计原理参见本节【问题2】解答。
	// 同时，该dmem_clk信号作为模块输出信号供仿真器进行观察。
	// 宏模块lpm_ram_dq的时序要求参见其时序图。

endmodule



