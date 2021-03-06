RSpec.describe NetworkX::MultiGraph do
  subject { graph }

  let(:graph) { described_class.new(name: 'Cities', type: 'undirected') }

  before do
    graph.add_nodes(%w[Nagpur Mumbai])
    graph.add_edge('Nagpur', 'Mumbai')
    graph.add_edges([%w[Nagpur Chennai], %w[Chennai Bangalore]])
    graph.add_node('Kolkata')
  end

  context 'when graph has been assigned attributes' do
    its('graph') { is_expected.to eq(name: 'Cities', type: 'undirected') }
  end

  context 'when a new node/s has/have been created' do
    its('nodes') do
      is_expected.to eq('Kolkata' => {},
                        'Nagpur' => {},
                        'Mumbai' => {},
                        'Chennai' => {},
                        'Bangalore' => {})
    end
  end

  context 'when a new edge/s has/have been added' do
    its('adj') do
      is_expected.to eq('Nagpur' => {'Mumbai' => {0 => {}}, 'Chennai' => {0 => {}}},
                        'Bangalore' => {'Chennai' => {0 => {}}},
                        'Chennai' => {'Nagpur' => {0 => {}}, 'Bangalore' => {0 => {}}},
                        'Mumbai' => {'Nagpur' => {0 => {}}}, 'Kolkata' => {})
    end
  end

  context 'when node/s is/are removed' do
    before do
      graph.remove_node('Nagpur')
      graph.remove_nodes(%w[Chennai Mumbai])
    end

    its('nodes') { is_expected.to eq('Kolkata' => {}, 'Bangalore'=> {}) }
    its('adj') { is_expected.to eq('Kolkata' => {}, 'Bangalore' => {}) }
  end

  context 'when edge/s is/are removed' do
    before do
      graph.remove_edge('Nagpur', 'Mumbai')
      graph.remove_edges([%w[Nagpur Chennai], %w[Chennai Bangalore]])
    end

    its('adj') do
      is_expected.to eq('Kolkata' => {}, 'Bangalore' => {},\
                        'Nagpur' => {}, 'Chennai' => {}, 'Mumbai' => {})
    end
  end

  context 'when weighted edge/s is/are added' do
    before do
      graph.remove_nodes(%w[Chennai Bangalore])
      graph.add_weighted_edge('Nagpur', 'Mumbai', 15)
      graph.add_weighted_edges([%w[Nagpur Kolkata]], [10])
    end

    its('adj') do
      is_expected.to eq('Kolkata' => {'Nagpur' => {0 => {weight: 10}}},
                        'Mumbai' => {'Nagpur' => {1 => {weight: 15}, 0 => {}}},
                        'Nagpur' => {'Mumbai' => {1 => {weight: 15}, 0 => {}},
                                     'Kolkata' => {0 => {weight: 10}}})
    end
  end

  context 'when number of edges are calculated' do
    before do
      graph.add_edge('Nagpur', 'Mumbai')
    end

    its('number_of_edges') do
      is_expected.to eq 4
    end
  end

  context 'when size is called' do
    subject { graph.size(true) }

    before do
      graph.add_weighted_edge('Nagpur', 'Mumbai', 15)
    end

    it do
      is_expected.to eq 15
    end
  end

  context 'when subgraph is called' do
    subject { graph.subgraph(%w[Nagpur Mumbai]) }

    its('nodes') do
      is_expected.to eq('Nagpur' => {}, 'Mumbai' => {})
    end

    its('adj') do
      is_expected.to eq('Nagpur' => {'Mumbai' => {0 => {}}}, 'Mumbai' => {'Nagpur' => {0 => {}}})
    end
  end

  context 'when edges_subgraph is called' do
    subject { graph.edge_subgraph([%w[Nagpur Mumbai], %w[Nagpur Chennai]]) }

    its('nodes') do
      is_expected.to eq('Nagpur' => {}, 'Mumbai' => {}, 'Chennai' => {})
    end

    its('adj') do
      is_expected.to eq('Nagpur' => {'Chennai' => {0 => {}}, 'Mumbai' => {0 => {}}},
                        'Mumbai' => {'Nagpur' => {0 => {}}},
                        'Chennai' => {'Nagpur' => {0 => {}}})
    end
  end

  context 'when to_undirected is called' do
    subject { graph.to_undirected }

    its('adj') do
      is_expected.to eq('Nagpur' => {'Mumbai' => {}, 'Chennai' => {}},
                        'Bangalore' => {'Chennai' => {}},
                        'Chennai' => {'Nagpur' => {}, 'Bangalore' => {}},
                        'Mumbai' => {'Nagpur' => {}}, 'Kolkata' => {})
    end
  end
end
