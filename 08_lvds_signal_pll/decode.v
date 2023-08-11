//module name:			decode module ver 2008.4.25
//module function:		8B/10B decoder
//module author:		W.D.L.
//module notes:			
//module version history:  
						

//Thanks to Chuck Benz��this module is mostly copied from his original module
`timescale 1ns / 100ps
module decode (
	clk,
	rst_n,
	datain,
	lock_n,
	dataout,
	kout,
	code_err
	) ;
input [9:0] datain;
input lock_n;
input clk;
input rst_n;

output [7:0] dataout;
output kout;
output code_err;
//reg [7:0] dataout;
reg kout;
reg code_err;

reg ao,bo,co,d_o,eo,fo,go,ho;

reg ai,ai_1,ai_2;
reg bi,bi_1,bi_2;
reg ci,ci_1,ci_2;
reg di,di_1,di_2;
reg ei,ei_1,ei_2;
reg ii,ii_1,ii_2;
reg fi,fi_1,fi_2;
reg gi,gi_1,gi_2;
reg hi,hi_1,hi_2;
reg ji,ji_1,ji_2;
////////////////////first step reg///////////////////////////////
reg p22,p13,p31,p04,p40,fghjp13,fghjp31;//fghj22,;  



////////////////////second step reg//////////////////////////////
reg p04_2,p40_2;              
reg p22bceeqi,p22bncneeqi,p13in,p31i,p13dei,p22aceeqi,p22ancneeqi;
reg p13en,anbnenin,abei,cndnenin;
reg disp6p,disp6n,disp4p,disp4n;
reg k28p;
reg fghjp13_2,fghjp31_2;
reg ko_temp1,ko_temp2,ko_temp3,ko_temp4;
reg err1,err2,err3,err4,err5,err6,err7;
reg fo_1,fo_2,fo_3,fo_4;
reg go_1,go_2,go_3,go_4;
reg ho_1,ho_2,ho_3,ho_4,ho_5,ho_6;

reg ao_test,bo_test,co_test,do_test,eo_test;
wire ao_temp,bo_temp,co_temp,do_temp,eo_temp;

always @ (posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		kout <= 1'b0;
		code_err <= 1'b1;
	end
	else begin
		if( lock_n == 0 )begin
			ai <= datain[0];
			bi <= datain[1];
			ci <= datain[2];
			di <= datain[3];
			ei <= datain[4];
			ii <= datain[5];
			fi <= datain[6];
			gi <= datain[7];
			hi <= datain[8];
			ji <= datain[9];		
		end
		else begin
			ai <= 0;
			bi <= 0;
			ci <= 0;
			di <= 0;
			ei <= 0;
			ii <= 0;
			fi <= 0;
			gi <= 0;
			hi <= 0;
			ji <= 0;
		end
		
		/////////////first step///////////////////////
		p22 <= (ai & bi & !ci & !di)|(ci & di & !ai & !bi)|((ai^bi) & (ci^di));
		p13 <= ((ai^bi) & !ci & !di)|((ci^di) & !ai & !bi);
		p31 <= ((ai^bi) & ci & di)|((ci^di) & ai & bi);
		p40 <= ai & bi & ci & di;
		p04 <= !ai & !bi & !ci & !di;
//		fghj22 <= (fi & gi & !hi & !ji)|(!fi & !gi & hi & ji)|((fi^gi) & (hi^ji));
		fghjp13 <= ((fi^gi) & !hi & !ji)|((hi^ji) & !fi & !gi);
		fghjp31 <= ((fi^gi) & hi & ji)|((hi^ji) & fi & gi);
		ai_1 <= ai;
		bi_1 <= bi;
		ci_1 <= ci;
		di_1 <= di;
		ei_1 <= ei;
		fi_1 <= fi;
		gi_1 <= gi;
		hi_1 <= hi;
		ii_1 <= ii;
		ji_1 <= ji;	
		k28p <= ! (ci | di | ei | ii);

		///////////////////////////second step/////////////////////////////
		p22bceeqi <= p22 & bi_1 & ci_1 & (ei_1 == ii_1) ;
		p22bncneeqi <= p22 & !bi_1 & !ci_1 & (ei_1 == ii_1) ;
		p13in <= p13 & !ii_1 ;
		p31i <= p31 & ii_1 ;
		p13dei <= p13 & di_1 & ei_1 & ii_1 ;
		p22aceeqi <= p22 & ai_1 & ci_1 & (ei_1 == ii_1) ;
		p22ancneeqi <= p22 & !ai_1 & !ci_1 & (ei_1 == ii_1) ;
		p13en <= p13 & !ei_1 ;
		anbnenin <= !ai_1 & !bi_1 & !ei_1 & !ii_1 ;
		abei <= ai_1 & bi_1 & ei_1 & ii_1 ;
		cndnenin <= !ci_1 & !di_1 & !ei_1 & !ii_1 ;
		
		p40_2 <= p40;
		p04_2 <= p04;
		fghjp13_2 <= fghjp13;
		fghjp31_2 <= fghjp31;
 
		ko_temp1 <= (ci_1 & di_1 & ei_1 & ii_1);
		ko_temp2 <= (!ci_1 & !di_1 & !ei_1 & !ii_1);
		ko_temp3 <= (p13 & !ei_1 & ii_1 & gi_1 & hi_1 & ji_1);
		ko_temp4 <= (p31 & ei_1 & !ii_1 & !gi_1 & !hi_1 & !ji_1) ;
				
		disp6p <= (p31 & (ei_1 | ii_1)) | (p22 & ei_1 & ii_1) ;
		disp6n <= (p13 & ! (ei_1 & ii_1)) | (p22 & !ei_1 & !ii_1) ;
		disp4p <= fghjp31 ;
		disp4n <= fghjp13 ;
		
		fo_1 <= (ji_1 & !fi_1 & (hi_1 | !gi_1 | k28p));
		fo_2 <= (fi_1 & !ji_1 & (!hi_1 | gi_1 | !k28p));
		fo_3 <= (k28p & gi_1 & hi_1);
		fo_4 <= (!k28p & !gi_1 & !hi_1);
		
		go_1 <= (ji_1 & !fi_1 & (hi_1 | !gi_1 | !k28p));
		go_2 <= (fi_1 & !ji_1 & (!hi_1 | gi_1 | k28p));
		go_3 <= (!k28p & gi_1 & hi_1);
		go_4 <= (k28p & !gi_1 & !hi_1);
		
		ho_1 <= (!fi_1 & gi_1 & !hi_1 & ji_1 & !k28p);
		ho_2 <= (!fi_1 & gi_1 & hi_1 & !ji_1 & k28p);
		ho_3 <= (fi_1 & !gi_1 & !hi_1 & ji_1 & !k28p);
		ho_4 <= (fi_1 & !gi_1 & hi_1 & !ji_1 & k28p);
		ho_5 <= (!fi_1 & gi_1 & hi_1 & ji_1);
		ho_6 <= (fi_1 & !gi_1 & !hi_1 & !ji_1);

		err1 <= (fi_1 & gi_1 & hi_1 & ji_1) | (!fi_1 & !gi_1 & !hi_1 & !ji_1);
		err2 <= (p13 & !ei_1 & !ii_1) | (p31 & ei_1 & ii_1);
		err3 <= (ei_1 & ii_1 & fi_1 & gi_1 & hi_1) | (!ei_1 & !ii_1 & !fi_1 & !gi_1 & !hi_1);
		err4 <= (ei_1 & !ii_1 & gi_1 & hi_1 & ji_1) | (!ei_1 & ii_1 & !gi_1 & !hi_1 & !ji_1);
		err5 <= (!p31 & ei_1 & !ii_1 & !gi_1 & !hi_1 & !ji_1) | (!p13 & !ei_1 & ii_1 & gi_1 & hi_1 & ji_1);
		err6 <= (((ei_1 & ii_1 & !gi_1 & !hi_1 & !ji_1) | (!ei_1 & !ii_1 & gi_1 & hi_1 & ji_1)) & !((ci_1 & di_1 & ei_1) | (!ci_1 & !di_1 & !ei_1))); 
		err7 <= (ci_1 & di_1 & ei_1 & ii_1 & !fi_1 & !gi_1 & !hi_1) | (!ci_1 & !di_1 & !ei_1 & !ii_1 & fi_1 & gi_1 & hi_1);
		
        ai_2 <= ai_1;
		bi_2 <= bi_1;
		ci_2 <= ci_1;
		di_2 <= di_1;
		ei_2 <= ei_1;
		fi_2 <= fi_1;
		gi_2 <= gi_1;
		hi_2 <= hi_1;
		ii_2 <= ii_1;
		ji_2 <= ji_1;	
				
		//////////////////////////third step////////////////////////////////
		ao <= ai_2^(p22bncneeqi | p31i | p13dei | p22ancneeqi | p13en | abei | cndnenin);
		bo <= bi_2^(p22bceeqi | p31i | p13dei | p22aceeqi | p13en | abei | cndnenin);
		co <= ci_2^(p22bceeqi | p31i | p13dei | p22ancneeqi | p13en | anbnenin | cndnenin);
		d_o <= di_2^(p22bncneeqi | p31i | p13dei | p22aceeqi |p13en | abei | cndnenin);
		eo <= ei_2^(p22bncneeqi | p13in | p13dei | p22ancneeqi | p13en | anbnenin | cndnenin);
		
		fo <= fo_1 | fo_2 | fo_3 | fo_4;
		go <= go_1 | go_2 | go_3 | go_4;
		ho <= ((ji_2 ^ hi_2) & !(ho_1 | ho_2 | ho_3 | ho_4)) | ho_5 | ho_6;
		
		
		kout <= ko_temp1 | ko_temp2 | ko_temp3 | ko_temp4;
		code_err <=  p40_2 | p04_2 | err1 | err2 | err3 | err4 | err5 | err6 | err7 | (disp6p & disp4p) | (disp6n & disp4n) |
    			(ai_2 & bi_2 & ci_2 & !ei_2 & !ii_2 & ((!fi_2 & !gi_2) | fghjp13_2)) |
    			(!ai_2 & !bi_2 & !ci_2 & ei_2 & ii_2 & ((fi_2 & gi_2) | fghjp31_2)) |
    			(fi_2 & gi_2 & !hi_2 & !ji_2 & disp6p) |
    			(!fi_2 & !gi_2 & hi_2 & ji_2 & disp6n);
	end
	
end

assign dataout = {ho, go, fo, eo, d_o, co, bo, ao} ;

endmodule
