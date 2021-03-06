require 'spec_helper_capybara'
include Faker

def create_ladder slug, name, description = ''
  Ladder.create(slug: slug, name: name, description: description)
end

def visit_sports_ladder
  visit '/'
end

feature 'Sports Ladder Management Page' do


  it 'should display a title' do
    visit_sports_ladder
    expect(page).to have_title 'Sports Ladder'
  end


  it 'should display a navigation heading' do
    visit_sports_ladder
    expect(page).to have_selector('#navHeading', :text => 'Sports Ladder')
  end


  it 'should display a page heading' do
    visit_sports_ladder
    expect(page).to have_selector('#pageHeading', :text => 'Sports Ladder')
  end


  it 'should display a list of existing ladders ordered alphabetically' do
    second_ladder = create_ladder(Lorem.characters(5), 'B', 'Test ladder that is alphabetically second')
    third_ladder = create_ladder(Lorem.characters(5), 'C', 'Test ladder that is alphabetically third')
    first_ladder = create_ladder(Lorem.characters(5), 'A', 'Test ladder that is alphabetically first')

    visit_sports_ladder

    ladders = page.all('#ladderList li')

    expect(ladders[0].find('a').text).to eq first_ladder.name
    expect(ladders[0].find('span').text).to eq first_ladder.description

    expect(ladders[1].find('a').text).to eq second_ladder.name
    expect(ladders[1].find('span').text).to eq second_ladder.description

    expect(ladders[2].find('a').text).to eq third_ladder.name
    expect(ladders[2].find('span').text).to eq third_ladder.description
  end


  it 'should be possible to select a specific ladder to view' do
    ladder = Ladder.create(slug: Lorem.characters(10), name: Lorem.sentence(3))

    visit_sports_ladder
    page.click_link(ladder.name)

    expect(page).to have_title "Sports Ladder - #{ladder.name}"
  end


  [0, 1, 10].each do |number_of_existing_ladders|
    it 'should be possible to create a ladder and then view it' do

      number_of_existing_ladders.times do
        create_ladder(Lorem.characters(5), Lorem.characters(10), Lorem.sentence(4))
      end

      visit_sports_ladder

      new_ladder_name = Lorem.characters(10)
      new_ladder_description = Lorem.sentence(5)

      fill_in 'ladderName', :with => new_ladder_name
      fill_in 'ladderDescription', :with => new_ladder_description
      click_button('Create ladder')
      expect(page).to have_selector('#ladderList li.ladder', :count => number_of_existing_ladders + 1)
      expect(page).to have_selector('#ladderList li.ladder dt a', :text => new_ladder_name)
      expect(page).to have_selector('#ladderList li.ladder dd', :text => new_ladder_description)

      page.click_link(new_ladder_name)
      expect(page).to have_title "Sports Ladder - #{new_ladder_name}"
    end
  end
end

