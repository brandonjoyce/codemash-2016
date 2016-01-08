feature 'Cooking spaghetti' do
  scenario 'pasta is properly cooked' do
    it 'is al dente' do
      ...
    end
  end
end

feature 'Cooking pasta' do
  scenario 'spaghetti' do
    it 'is al dente' do
      cook_pasta 'spaghetti'
      expect(subject).to be_al_dente
    end
  end

  scenario 'tortellini' do
    it 'is al dente' do
      cook_pasta 'tortellini'
      expect(subject).to be_al_dente
    end
  end
end

it 'is al dente' do
  chef = Chef.new
  chef.cook_spaghetti
  expect(chef.pasta).to be_al_dente
end

def prepare_food
  case @food
  when :pasta
    pour_pasta_in_water if box_open? && water_boiled? && !pasta_already_in_water?
    loop do
      cook_for 30
      return if pasta_overdone?
      break if pasta_done?
    end
    tell_sous_chef_we_need_the_sauce
  when :salad

describe '#prepare_food' do
  context ?????   # when does this happen?
    it 'cooks the pasta and adds the sauce'
