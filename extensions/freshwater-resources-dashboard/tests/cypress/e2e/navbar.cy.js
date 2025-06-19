describe('navbar', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('has a navbar', () => {
    cy.get('#app_header').should('exist')
  })

  it('has a Lets talk button', () => {
    cy.get('.btn-cta').should('exist')
  })

})
