with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO, Unbound_Stack;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

-- procedure Integer_Calculator
procedure Integer_Calculator is
   
   package Unbound_Character_Stack is new Unbound_Stack(Character);
   package Unbound_Float_Stack is new Unbound_Stack(Float);
   use Unbound_Character_Stack, Unbound_Float_Stack;
   
   Operator_Stack : Unbound_Character_Stack.Stack;
   Operand_Stack : Unbound_Float_Stack.Stack;
   
   Buffer : String(1..1000);
   Last :Natural;
   
   Index : Integer := 1;
   Result : Float;   
   Operator : Character;
   Operand : Float;
   Expect_Operand : Boolean := True;
   Expression_Error : exception;
   
   procedure Apply is
      Left, Right : Float := 0.0;
      Total : Float := 0.0;
      Operator: Character;
   begin
      Pop(Right,Operand_Stack);
      Pop(Left,Operand_Stack);
      Pop(Operator,Operator_Stack);

      case Operator is
	 when '+' => Push(Left + Right, Operand_Stack);
	 when '-' => Push(Left - Right, Operand_Stack);
	 when '*' => Push(Left * Right, Operand_Stack);
	 when '/' => Push(Left / Right, Operand_Stack);
	 when others => raise Expression_Error;
      end case;
   end Apply;
   
   function Precedence(Operator : Character) return Integer is
   begin
      case Operator is
	 when '+' | '-' => return 1;
	 when '*' | '/' => return 2;
	 when '#' | '(' => return 0;
	 when others => raise Expression_Error;
      end case;
   end Precedence;
      
   --function Evaluate return Integer
   --Evaluates the integer expression in Buffer and returns the results.
   --An Expression_Error is raised if the expression has an error;
   function Evaluate return Float is
      --Operator_Stack : Unbound_Character_Stack.Stack;
      --Operand_Stack : Unbound_Integer_Stack.Stack;
      
      Result : Float;
      
      
   begin --Evaluate
	 --Process the expression left to right one character at a time.
      Push('#',Operator_Stack);
      while Index <= Last loop
	 case Buffer(Index) is
	    when '0'..'9' =>
	       --The character starts an operand. Extract it and push it
	       --on the Operand Stack
	       declare
		  Value : Integer := 0;
		  Pos : Float := 0.0;
		  Count : Float := 0.0;
		  Valuepush : Float := 0.0;
		  Vconvert : Float := 0.0;
		  Devider : Float := 1.0;
		  Dec : Boolean := False;
		  
	      begin
		  while Index <= Last and then
		    Buffer(Index) in '0'..'9'| '.' loop
		     --get the position that the decimal place is read in
		     if Buffer(Index) = '.' then
			Dec := True;
			Pos := Count;
		       Index := Index + 1;
		     end if;
		     --get the total value of the integers
		     Value := Value*10+(Character'Pos(Buffer(Index))-Character'Pos('0'));
		     Index := Index + 1;
		     Count := Count + 1.0;
		  end loop;
		  --Devide the total number by the decimal place to get actual float number
		  Pos := Count - Pos;
		  if Dec then
		     while Pos /= 0.0 loop
			Devider := Devider * 10.0;
			Pos := Pos - 1.0;
		     end loop;
		  end if;

		  Vconvert := Float(Value);
		  Valuepush := Vconvert / Devider;
		  --Put(Valuepush);
		  --New_Line;
		  Push(Valuepush,Operand_Stack);
		  --Push(Value, Operand_Stack);
		  Expect_Operand := False;
	       end;
	       
	    when '+' | '-' | '*' | '/' =>
	       --The character is an operator.  Apply any pending operators
	       --(on the Operator_Stack) whose precedence is greater than
	       --or equal to this operator.  Then, push the operator on the
	       --Operator_Stack.
	       while Precedence(Buffer(Index)) <= Precedence(Top(Operator_Stack))loop
		  Apply;
	       end loop;
		  Push(Buffer(Index),Operator_Stack);
		  Expect_Operand := True;
		  Index := Index + 1;
	    when '(' =>
	       Push(Buffer(Index),Operator_Stack);
	       Index := Index + 1;
	    when ')' =>
	       while Precedence(Top(Operator_Stack)) > Precedence('(') loop
		  Apply;
	       end loop;
	       Pop(Operator, Operator_Stack);
	      
	       if Operator /= '(' then
		 Put("Missing left parenthesis");
		  raise Expression_Error;
	       end if;
	       Index := Index + 1;
	    when ' ' =>
	       --the character is a space. Ignore it.
	       Index := Index + 1;
	    when others =>
	       -- The character is something unexpected. Raise Expression_Error.
	       Put("Others");
	       raise Expression_Error;
	 end case;
      end loop;
      --We are at the end of the expression. Apply all of the pending operators.
      --The operand stack must have exactly one value, which is returned	 
      while Precedence(Top(Operator_Stack)) > Precedence('#') loop
	 --Put("bottomlooping");
	 Apply;
      end loop;
      Pop(Result,Operand_Stack);
      
      return Result;
	
   exception
      when Unbound_Character_Stack.Underflow | Unbound_Float_Stack.Underflow =>
	 Put("Under");
	 raise Expression_Error;
   end Evaluate;
   
   
   
begin --Calculator
      --Process all of the expression in standard input.
   while not End_Of_File loop
      --Read the next expression, evaluate it, and print the result.
      begin
	 Get_Line(Buffer, Last);
	 --Put_Line(Buffer(1..Last));
	 Index := 1;
	 Expect_Operand := True;
	 Result := Evaluate;
	 Put(Result);
	 New_Line;
      exception
	 when Expression_Error =>
	    Put_Line("EXPRESSION ERROR");
	 when others =>
	    Put_Line("ERROR");
      end;
   end loop;
end Integer_Calculator;
