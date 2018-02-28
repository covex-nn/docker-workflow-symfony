<?php

namespace App\Admin;

use App\Entity\User;
use FOS\UserBundle\Model\UserManagerInterface;
use Sonata\AdminBundle\Admin\AbstractAdmin;
use Sonata\AdminBundle\Datagrid\DatagridMapper;
use Sonata\AdminBundle\Datagrid\ListMapper;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Show\ShowMapper;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextType;

/**
 * Class UserAdmin
 */
class UserAdmin extends AbstractAdmin
{
    /**
     * @var UserManagerInterface
     */
    protected $userManager;

    /**
     * {@inheritdoc}
     */
    protected function configureListFields(ListMapper $listMapper)
    {
        $listMapper
            ->add('id')
            ->addIdentifier('email')
            ->addIdentifier('username')
            ->add('enabled')
            ->add(
                '_action', 'actions', array(
                    'actions' => array(
                        'show' => array(),
                    )
                )
            )
        ;
    }

    /**
     * {@inheritdoc}
     */
    public function getExportFields()
    {
        $exportFields = parent::getExportFields();

        return array_filter(
            $exportFields,
            function ($v) {
                return !in_array($v, array('password', 'salt'));
            }
        );
    }

    /**
     * @param ShowMapper $showMapper
     */
    protected function configureShowFields(ShowMapper $showMapper)
    {
        $showMapper
            ->add('id')
            ->add('email')
            ->add('username')
            ->add("rolesAsString")
            ->add('enabled')
        ;
    }

    /**
     * {@inheritdoc}
     */
    protected function configureDatagridFilters(DatagridMapper $filterMapper)
    {
        $filterMapper
            ->add('email')
            ->add('username')
        ;
    }

    /**
     * {@inheritdoc}
     */
    protected function configureFormFields(FormMapper $formMapper)
    {
        $сhoices = array();
        $container = $this->getConfigurationPool()->getContainer();
        foreach ($container->getParameter('security.role_hierarchy.roles') as $key => $value) {
            $choices[$key] = $key;
            foreach ($value as $name) {
                $choices[$name] = $name;
            }
        }
        asort($choices);

        $formMapper
            ->add('email')
            ->add('username')
            ->add('plainPassword', TextType::class, array(
                'required' => (!$this->getSubject() || is_null($this->getSubject()->getId())),
            ))
            ->add('roles', ChoiceType::class, [
                'choices'  => $choices,
                'multiple' => true
            ])
            ->add('enabled')
        ;
    }

    /**
     * {@inheritdoc}
     */
    public function getFormBuilder()
    {
        $this->formOptions['data_class'] = $this->getClass();

        $options = $this->formOptions;
        if (!$this->getSubject() || is_null($this->getSubject()->getId())) {
            $options['validation_groups'] = 'Registration';
        } else {
            $options['validation_groups'] = 'Profile';
        }

        $formBuilder = $this->getFormContractor()->getFormBuilder($this->getUniqid(), $options);

        $this->defineFormBuilder($formBuilder);

        return $formBuilder;
    }

    /**
     * {@inheritdoc}
     */
    public function preUpdate($user)
    {
        $this->userManager->updateCanonicalFields($user);
        $this->userManager->updatePassword($user);
    }

    /**
     * Set user manager
     *
     * @param UserManagerInterface $userManager User manager
     *
     * @return $this
     * @required
     */
    public function setUserManager(UserManagerInterface $userManager)
    {
        $this->userManager = $userManager;

        return $this;
    }
}
