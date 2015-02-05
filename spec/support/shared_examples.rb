shared_examples "require_signin" do
  before do
    clear_current_user
    action
  end
  it "redirects to signin path" do
    expect(response).to redirect_to signin_path
  end
  it "flashes error message" do
    expect(flash[:danger]).to_not be_nil
  end
end
