class AddSearchTermsToExpenseItems < ActiveRecord::Migration
  def up
    execute <<-SQL
      alter table expense_items add column fulltext_terms tsvector;

      create function expense_items_fulltext_terms_tfun() returns trigger as $$
      begin
        new.fulltext_terms :=
          to_tsvector(coalesce(new.description, '')) ||
          to_tsvector(coalesce(new.comment, ''));

        return new;
      end;
      $$ language 'plpgsql';

      create trigger expense_items_fulltext_terms_trig
      before insert or update
      of description, comment, fulltext_terms
      on expense_items for each row
      execute procedure expense_items_fulltext_terms_tfun();

      update expense_items set fulltext_terms = null;
    SQL
  end

  def down
    execute <<-SQL
      drop trigger if exists expense_items_fulltext_terms_trig on expense_items;
      drop function if exists expense_items_fulltext_terms_trig();
      alter table expense_items drop column fulltext_terms;
    SQL
  end
end
