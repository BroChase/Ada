package body Unbound_Stack is
  type Cell is record
    Item : Item_Type;
    Next : Stack;
  end record;
  procedure Push (Item : in Item_Type; Onto : in out Stack) is
  begin
    Onto := new Cell'(Item => Item, Next => Onto);
  end Push;
  Procedure Pop(Item : out Item_Type; From : in out Stack) is
  Begin
    if Is_Empty(From) then
      raise Underflow;
    else
      Item := From.Item;
      From := From.Next;
    end if;
  end Pop;
  
  function Top(From : in out Stack) return Item_Type is
  begin
     return From.Item;
  end Top;
  
  
  
  function Is_Empty(S: Stack) return Boolean is
  begin
    return S = null;
  end Is_Empty;
end Unbound_Stack;
