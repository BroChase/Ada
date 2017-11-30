generic
  type Item_Type is private;
package Unbound_Stack is
  type Stack is private;
  Underflow : exception;
  procedure Push (Item : in Item_Type; Onto : in out Stack);
  procedure Pop (Item : out Item_Type; From : in out Stack);
  function Top(From : in out Stack) return Item_Type;
  function Is_Empty (S : Stack) return Boolean;
private
  type Cell;
  type Stack is access Cell;
end Unbound_Stack;
