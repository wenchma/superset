"""empty message

Revision ID: d34b94022abf
Revises: 940ce70b144d
Create Date: 2019-01-18 11:29:11.548204

"""

# revision identifiers, used by Alembic.
revision = 'd34b94022abf'
down_revision = '940ce70b144d'

from alembic import op
import sqlalchemy as sa


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('tables', sa.Column('monitor_filter', sa.Text(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('tables', 'monitor_filter')
    # ### end Alembic commands ###
